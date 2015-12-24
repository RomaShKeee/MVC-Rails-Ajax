# Ruby On Rails - html5 offline test app

***
Simple RoR implementation of using application cache with rack-offline.
Main function is parsing links like 'https://www.google.com/' to 'google.com' in online / offline mode.

## That was used

[MDN Storage API](https://developer.mozilla.org/en-US/docs/Web/API/Storage)

[Rack::Offline](https://github.com/wycats/rack-offline)

[jQuery.offline](https://github.com/wycats/jquery-offline)


## What actual for use. (2016...)

[MDN Service Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) - [Browser compatibility](http://caniuse.com/#feat=serviceworkers)


# Setup
```
git clone https://github.com/RomaShKeee/MVC-Rails-Ajax.git
```
Clone repository
```
bundle install
```
Install gems
```
rake generate_appcache_file
```
Call rake task for generate appcache file
```
thin start
```
Start Thin server


### Using

Go to "http://localhost:3000"

And after the first start you can use it in offline.


