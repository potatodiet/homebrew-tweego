require "fileutils"

class Tweego < Formula
  desc "Tweego is a free (gratis and libre) command line compiler for Twine/Twee story formats, written in Go."
  homepage "https://www.motoslave.net/tweego"
  url "https://github.com/tmedwards/tweego/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "f58991ff0b5b344ebebb5677b7c21209823fa6d179397af4a831e5ef05f28b02"
  license "BSD-2-Clause"

  depends_on "go" => :build

  resource "storyformats" do
    url "https://github.com/tmedwards/tweego/releases/download/v2.1.1/tweego-2.1.1-macos-x64.zip"
    sha256 "93d8da9df25e6b08d9011175ecebe67bef76a639f3aa3b20b5deefb691316ef1"
  end

  EXECUTOR = %[
    #!/usr/bin/env ruby

    if ENV\["TWEEGO_PATH"\]
      system("tweego-bin", *ARGV)
    else
      system({ "TWEEGO_PATH" => File.join(__dir__, "../", "storyformats") }, "tweego-bin", *ARGV)
    end
  ].strip

  def install
    system "go", "get"
    system "go", "build", "-o", "tweego-bin"
    bin.install "tweego-bin"

    File.write "tweego", EXECUTOR
    bin.install "tweego"
    
    resource("storyformats").stage { prefix.install Dir["storyformats"] }
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test tweego`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
