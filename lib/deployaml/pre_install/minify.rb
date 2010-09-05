module Deployaml
  module PreInstall
    class Minify

      def run deployment, params
        yui_jar = File.join(
                File.dirname(__FILE__),
                '..', '..', '..', 'vendor', 'yuicompressor', 'build', 'yuicompressor-2.4.2.jar'
        )
        
        base_pattern = File.join(deployment.staging_path, '**')

        [Dir.glob(base_pattern + '*.js'), Dir.glob(base_pattern + '*.css')].each do |file|
          puts "Minifying #{file}"
          `java -jar #{yui_jar} #{file} -o #{file}`
        end

      end

    end
  end
end