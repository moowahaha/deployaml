module Deployaml
  module PreInstall
    class Minify

      def run deployment, params
        yui_jar = File.join(
                File.dirname(__FILE__),
                '..', '..', '..', 'vendor', 'yuicompressor', 'build', 'yuicompressor-2.4.2.jar'
        )
        
        base_pattern = [deployment.staging_path, '**']

        [Dir.glob(File.join(base_pattern + ['*.js'])), Dir.glob(File.join(base_pattern + ['*.css']))].flatten.each do |file|
          puts "Minifying #{file}"
          `java -jar #{yui_jar} #{file} -o #{file}`
        end

      end

    end
  end
end