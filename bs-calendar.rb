class BsCalendar < Formula
  desc "Nepali (Bikram Sambat) calendar in your macOS menu bar"
  homepage "https://github.com/projectashik/bs-calendar"
  version "v1.0.4-dc098eb"
  url "https://github.com/projectashik/bs-calendar/releases/download/v1.0.4-dc098eb/bs-calendar-macos.dmg"
  sha256 "8db72a1ea871d8ef6bfaf4cf942a8aec9d105535618cc42baccc79450233aef5"

  depends_on macos: ">= :ventura"

  def install
    # Mount the DMG
    system "hdiutil", "attach", cached_download, "-mountpoint", "/Volumes/BS Calendar", "-quiet"
    
    # Copy the app
    prefix.install "/Volumes/BS Calendar/bs-calendar.app"
    
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
