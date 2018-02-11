# Seagull
Service for working with configuration and service-discovery via [`etcd`](https://github.com/coreos/etcd) or [`consul`](https://www.consul.io/). Can be useful in microservices.   
[![Build Status](https://travis-ci.org/SeaBattle/seagull.svg?branch=master)](https://travis-ci.org/SeaBattle/seagull)
[![Coon](https://coon.justtech.blog/badge?full_name=SeaBattle/seagull)](https://coon.justtech.blog)

## Configuration
### Static
For configuration use `sys.config`:

    {seagull, 
        [
            {backend, {Backend, BackendUrl}}
        ]
    }
Where:  
__Backend__ is an module with implementation of `sc_backend`.
__BackendUrl__ is url to reach the service.  
Example:

    {seagull, 
            [
                {backend, {sc_backend_consul, "http://127.0.0.1:8500"}}
            ]
        }
### Dynamic
In case you don't know consul url on compilation time you do not need to specify seagull 
configuration in `sys.config`. Just when you obtain you module, url and other params call 
`seagull:add_backend/2/3`. Third argument is a proplist with all your options (listed below).  
Example:  

    seagull:add_backend(sc_backend_consul, "http://mydynamicconsul:8500", [{cache, #{enable => true, update_time => 15000}}]).
### Caching kv
You can cache kv storage in ets by adding `{cache, [{enable, true}]}` to 
`sys.config`. By default cache is `false`. Also you should update interval
for cache values to be synchronized with backend by adding 
`#{update_time => TimeMS}` to `cache` section. Default update interval is
5 sec.
If you don't need to update values, set `#{update_time => undefined}` to
 disable cache values updates.
Full Example:

    {seagull, 
            [
                {backend, {sc_backend_consul, "http://127.0.0.1:8500"}},
                {cache, #{enable => true, update_time => 15000}}
            ]
        }
### Service auto registration
To make registration of your service on application start - add `seagull` to
your applications and add this option to seagull conf in `sys.config`:

    {seagull, 
            [
                ...
                {autoregister, #{service => Service, address => Address, port => Port}},
                ...
            ]
        }
### On update callbacks (__Not implemented__)
If you enabled cache update - you can add callback function, which will 
be called, when value is updated.  
Remember, that callbacks are synchronous and are called from main conf sycle,
so do not do any long operations in them.  
Example:
    
    ResetAllPassFun = fun(NewPass) -> database_man ! {reset_pass, NewPass} end, 
    seagull:add_callback(<<"user_pass">>, ResetAllPassFun).
Callback can be removed with `remove_callback:/1` function.

## Usage
### Unified api
After configuring backend you can use unified api:

    1> seagull:get_services().
    #{<<"consul">> => [],<<"postgres">> => [],<<"redis">> => []}

### Consul special api
You can use consul special api with consul backend:

    1> seagull:dns_request("redis").
    [{1,1,6379,"tihon_home.node.dc1.consul"},
    {1,1,6379,"tihon_work.su.node.dc1.consul"}]
    2> seagull:get_service_near("redis").
    {ok, #{<<"Address">> => <<"192.168.1.204">>,
            <<"CreateIndex">> => 313,
            <<"ModifyIndex">> => 313,
            <<"Node">> => <<"tihon_work.su">>,
            <<"ServiceAddress">> => <<>>,
            <<"ServiceEnableTagOverride">> => false,
            <<"ServiceID">> => <<"tihon_work.su:redis:6379">>,
            <<"ServiceName">> => <<"redis">>,
            <<"ServicePort">> => 6379,
            <<"ServiceTags">> => [],
            <<"TaggedAddresses">> => #{<<"wan">> => <<"192.168.1.204">>}}, 
            [#{<<"Address">> => <<"192.168.1.105">>,
                <<"CreateIndex">> => 231,
                <<"ModifyIndex">> => 231,
                <<"Node">> => <<"tihon_home">>,
                <<"ServiceAddress">> => <<>>,
                <<"ServiceEnableTagOverride">> => false,
                <<"ServiceID">> => <<"tihon_home:redis:6379">>,
                <<"ServiceName">> => <<"redis">>,
                <<"ServicePort">> => 6379,
                <<"ServiceTags">> => [],
                <<"TaggedAddresses">> => #{<<"lan">> => <<"192.168.1.105">>,
                    <<"wan">> => <<"192.168.1.105">>}}]

### Testing
To run tests of backends you will need this backends running and accessible.
`sc_backend_consul` tries to find consul on `http://127.0.0.1:8500`, and 
`sc_backend_etcd` tries to find etcd on `http://127.0.0.1:2379`.  
You can use `install-deps.sh` script for getting executables of theese two 
deps downloaded to `$HOME/consul` and `$HOME/etcd`.
