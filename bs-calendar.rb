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
    
    # Copy the app using cp -R
    system "cp", "-R", "/tmp/bs-calendar-dmg/bs-calendar.app", "#{prefix}/"
    
    # Unmount
    system "hdiutil", "detach", "/tmp/bs-calendar-dmg", "-force", "-quiet"
    
    # Create a wrapper script
    (bin/"bs-calendar").write <<~EOS
      #!/bin/bash
      open "#{prefix}/bs-calendar.app"
    EOS
    
    chmod 0755, bin/"bs-calendar"
  end

  def post_install
    # Remove quarantine attribute automatically
    system "xattr", "-cr", "#{prefix}/bs-calendar.app"
  end

  def caveats
    <<~EOS
      BS Calendar has been installed!

      To launch:
        bs-calendar

      Or use Spotlight to search for "BS Calendar"

      The app will appear in your menu bar when launched.
    EOS
  end

  test do
    assert_predicate prefix/"bs-calendar.app", :exist?
  end
end
