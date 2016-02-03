require 'html/proofer'

HTML::Proofer.new('./_site',   verbosity: :error,
                               ssl_verifypeer: false,
                               url_ignore: [
                                 /plus.google.com\/share/,
                                 /twitter.com\/intent\/tweet/,
                                 /www.facebook.com\/sharer\/sharer.php/,
                                 /facebook.com\/vishnu667/,
                                 /github.com\/vishnu667/,
                                 /instagram.com\/vishnu667/,
                                 /linkedin.com\/in\/vishnu667/,
                                 /mademistakes.com\/work\/minimal-mistakes-jekyll-theme\//,
                                 /plus.google.com\/\+vishnu667/,
                                 /stackoverflow.com\/users\/2104970\/vishnu667/,
                                 /twitter.com\/vishnu667/,
                                 /www.flickr.com\/vishnu667/
                               ]).run
