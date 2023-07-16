class Tapi < Formula
  desc "Apple TAPI library (tpoechtrager fork)"
  homepage "https://opensource.apple.com/tarballs/tapi"
  url "https://github.com/tpoechtrager/apple-libtapi/archive/1100.0.11.tar.gz"
  sha256 "bef360e713852f451383a7f1fdd4abfd17ee2d937778cd757708e52595d77b78"
  license "APSL-2.0"

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/tapi-1100.0.11"
    sha256 cellar: :any, monterey: "b5e2c6fc9e3bf532475d77823ffb4f878317991da909320ecdf9307e89689ff2"
  end

  keg_only "provided by Xcode CLT"

  depends_on "cmake" => :build

  def install
    append_includes = ["-I#{buildpath}/src/llvm/projects/clang/include -I#{buildpath}/build/projects/clang/include"]

    args = %W[
      -DCMAKE_CXX_FLAGS=#{append_includes.join(" ")}
      -DLLVM_ENABLE_PROJECTS=libtapi
      -DLLVM_ENABLE_TERMINFO=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DTAPI_FULL_VERSION=#{version}
      -DTAPI_INCLUDE_TESTS=OFF
    ]
    args << "-DPYTHON_EXECUTABLE=/usr/bin/python3" if MacOS.version > :catalina
    args << "-DPYTHON_EXECUTABLE=/usr/bin/python2.7" if MacOS.version <= :catalina

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "../src/llvm",
             *args, *std_cmake_args
      system "make", "libtapi", "tapi"
      system "make", "install-libtapi", "install-tapi-headers", "install-tapi"
    end
  end

  test do
    system "#{bin}/tapi", "--version"
  end
end