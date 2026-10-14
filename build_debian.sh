tldr_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$tldr_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <tldr_version> <build_version> [architecture]"
    echo "Example: $0 1.13.1 1 arm64"
    echo "Example: $0 1.13.1 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

# Function to map Debian architecture to tlrc release name
# (upstream project is tlrc, the binary and the package are called tldr).
# The musl builds are fully static, so the package has no runtime dependencies.
get_tlrc_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "tlrc-v${tldr_VERSION}-x86_64-unknown-linux-musl"
            ;;
        "arm64")
            echo "tlrc-v${tldr_VERSION}-aarch64-unknown-linux-musl"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to build for a specific architecture
build_architecture() {
    local build_arch=$1
    local tlrc_release

    tlrc_release=$(get_tlrc_release "$build_arch")
    if [ -z "$tlrc_release" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64"
        return 1
    fi

    echo "Building for architecture: $build_arch using $tlrc_release"

    # Clean up any previous builds for this architecture
    rm -rf "$tlrc_release" || true
    rm -f "${tlrc_release}.tar.gz" || true

    # Download and extract tlrc binary for this architecture
    if ! wget "https://github.com/tldr-pages/tlrc/releases/download/v${tldr_VERSION}/${tlrc_release}.tar.gz"; then
        echo "❌ Failed to download tlrc binary for $build_arch"
        return 1
    fi

    # tlrc tarballs are flat (tldr, tldr.1, LICENSE, README.md, completions/),
    # extract into a per-release directory
    mkdir -p "$tlrc_release"
    if ! tar -xf "${tlrc_release}.tar.gz" -C "$tlrc_release"; then
        echo "❌ Failed to extract tlrc binary for $build_arch"
        return 1
    fi

    rm -f "${tlrc_release}.tar.gz"

    if [ ! -f "$tlrc_release/tldr" ]; then
        echo "❌ Unexpected tarball layout: $tlrc_release/tldr not found"
        return 1
    fi

    # Build packages for the supported Debian distributions (trixie and later)
    declare -a arr=("trixie" "forky" "sid")

    for dist in "${arr[@]}"; do
        FULL_VERSION="$tldr_VERSION-${BUILD_VERSION}~${dist}_${build_arch}"
        echo "  Building $FULL_VERSION"

        if ! docker build . -t "tldr-$dist-$build_arch" \
            --build-arg DEBIAN_DIST="$dist" \
            --build-arg tldr_VERSION="$tldr_VERSION" \
            --build-arg BUILD_VERSION="$BUILD_VERSION" \
            --build-arg FULL_VERSION="$FULL_VERSION" \
            --build-arg ARCH="$build_arch" \
            --build-arg TLRC_RELEASE="$tlrc_release"; then
            echo "❌ Failed to build Docker image for $dist on $build_arch"
            return 1
        fi

        id="$(docker create "tldr-$dist-$build_arch")"
        if ! docker cp "$id:/tldr_$FULL_VERSION.deb" - > "./tldr_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb package for $dist on $build_arch"
            return 1
        fi

        if ! tar -xf "./tldr_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb contents for $dist on $build_arch"
            return 1
        fi
    done

    # Clean up extracted directory
    rm -rf "$tlrc_release" || true

    echo "✅ Successfully built for $build_arch"
    return 0
}

# Main build logic
if [ "$ARCH" = "all" ]; then
    echo "🚀 Building tldr $tldr_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""

    # All supported architectures (upstream publishes x86_64 and aarch64 only)
    ARCHITECTURES=("amd64" "arm64")

    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="

        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi

        echo ""
    done

    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la tldr_*.deb
else
    # Build for single architecture
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi
