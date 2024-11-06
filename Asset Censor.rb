module Cache
  class << self  
    alias_method :unaltered_load_bitmap, :load_bitmap
    def load_bitmap(folder_name, filename, hue = 0)
      if $game_switches && $game_switches[6] && has_censored_version?(folder_name + filename)
        return unaltered_load_bitmap(censored_folder + folder_name, filename, hue)
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
      "censored/"
    end
  end
end
