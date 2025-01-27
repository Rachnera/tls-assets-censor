module Cache
  class << self  
    alias_method :unaltered_load_bitmap, :load_bitmap
    def load_bitmap(folder_name, filename, hue = 0)
      file_path = folder_name + filename
      if $game_switches && $game_switches[6]
        # Purposefully ignore System/ images (like the titlescreen) and likewise
        if file_path.start_with?('Graphics/')
          key_path = file_path.sub('Graphics/', '')
          if has_censored_version?(key_path)
            return unaltered_load_bitmap(censored_folder, key_path, hue)
          end
        end
      end

      return unaltered_load_bitmap(folder_name, filename, hue)
    end

    def has_censored_version?(filepath)
      @censored_or_not ||= {}

      return @censored_or_not[filepath] if @censored_or_not.has_key?(filepath)

      begin
        normal_bitmap(censored_folder + filepath)
        @censored_or_not[filepath] = true
      rescue Errno::ENOENT
        @censored_or_not[filepath] = false
      end
      @censored_or_not[filepath]
    end

    def censored_folder
      "Graphics/SFW/"
    end
  end
end
