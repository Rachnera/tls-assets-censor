module Cache
  class << self  
    alias_method :unaltered_load_bitmap, :load_bitmap
    def load_bitmap(folder_name, filename, hue = 0)
      if try_to_load_censored_version_instead?(folder_name, filename)
        begin
          return unaltered_load_bitmap("censored/" + folder_name, filename, hue)
        rescue Errno::ENOENT
          # No censored version of the image found, proceed as usual
        end
      end

      return unaltered_load_bitmap(folder_name, filename, hue)
    end

    def try_to_load_censored_version_instead?(folder_name, filename)
      # Skip if NSFW is on
      return false unless $game_switches && $game_switches[6]

      # Skip if image already in cache, so supposedly checked previously
      return false if @cache && include?(folder_name + filename)

      true
    end
  end
end
