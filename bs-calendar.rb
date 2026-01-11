class BsCalendar < Formula
  desc "Nepali (Bikram Sambat) calendar in your macOS menu bar"
  homepage "https://github.com/projectashik/bs-calendar-mac"
  version "v1.0.7-4ce619d"
  url "https://github.com/projectashik/bs-calendar-mac/releases/download/v1.0.7-4ce619d/bs-calendar-macos.dmg"
  sha256 "67aad7e41d1d37bd70c7dc0e79cc14acb1e5b8604c32ca20f691d5ec96008e45"

  depends_on macos: :ventura

  def install
    # Mount the DMG to /tmp to avoid conflicts
    system "hdiutil", "attach", cached_download, "-mountpoint", "/tmp/bs-calendar-dmg", "-nobrowse", "-quiet"
    
    # Install to /Applications for Spotlight visibility
    app = Pathname.new("/Applications/bs-calendar.app")
    FileUtils.rm_rf(app) if app.exist?
    system "cp", "-R", "/tmp/bs-calendar-dmg/bs-calendar.app", "/Applications/"
    
    # Unmount
    system "hdiutil", "detach", "/tmp/bs-calendar-dmg", "-force", "-quiet"
    
    # Create a wrapper script
    (bin/"bs-calendar").write <<~EOS
      #!/bin/bash
      open /Applications/bs-calendar.app
    EOS
    
    chmod 0755, bin/"bs-calendar"
  end

  def post_install
    # Remove quarantine attribute automatically
    system "xattr", "-cr", "/Applications/bs-calendar.app"
  end

  def caveats
    <<~EOS
      BS Calendar has been installed to /Applications!

      To launch:
        bs-calendar

      Or use Spotlight (⌘+Space) to search for "BS Calendar"

      The app will appear in your menu bar when launched.
    EOS
  end

  test do
    assert_predicate prefix/"bs-calendar.app", :exist?
  end
end
