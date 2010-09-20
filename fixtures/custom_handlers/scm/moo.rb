require File.dirname(__FILE__) + '/../../../lib/deployaml/scm_base'

module Deployaml
  module Scm
    class Moo < ScmBase
      def fetch_files
        raise "MOO!"
      end
    end
  end
end