class BsCalendar < Formula
  desc "Nepali (Bikram Sambat) calendar in your macOS menu bar"
  homepage "https://github.com/projectashik/bs-calendar-mac"
  version "v1.0.7-4ce619d"
  url "https://github.com/projectashik/bs-calendar-mac/releases/download/v1.0.7-4ce619d/bs-calendar-macos.dmg"
  sha256 "67aad7e41d1d37bd70c7dc0e79cc14acb1e5b8604c32ca20f691d5ec96008e45"

  depends_on macos: :ventura

  def install
    # Mount the DMG
    system "hdiutil", "attach", cached_download, "-mountpoint", "/Volumes/BS Calendar", "-nobrowse", "-quiet"
    
    # Copy the app using ditto to preserve permissions and signatures
    system "ditto", "/Volumes/BS Calendar/bs-calendar.app", "#{prefix}/bs-calendar.app"
    
    # Unmount
    system "hdiutil", "detach", "/Volumes/BS Calendar", "-quiet"
    
    # Create a wrapper script
    (bin/"bs-calendar").write <<~EOS
      #!/bin/bash
      open "#{prefix}/bs-calendar.app"
    EOS
  end

  def caveats
    <<~EOS
      BS Calendar has been installed to:
        #{prefix}/bs-calendar.app

      To launch BS Calendar:
        bs-calendar

      Or open from Applications:
        open #{prefix}/bs-calendar.app

      Note: On first launch, you may need to:
        1. Right-click the app → Open
        2. Or run: xattr -cr "#{prefix}/bs-calendar.app"
    EOS
  end

  test do
    assert_predicate prefix/"bs-calendar.app", :exist?
  end
end
