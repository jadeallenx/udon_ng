udon
====

This is the "next generation" of *udon*, an example application to demonstrate
and learn about riak_core.

It should work on Erlang 19. OTP 20 doesn't currently compile without quite a bit
of work on dependencies.

This was first presented at [Erlang and Elixir Factory Lite Bengalore 2017][1].

Building a docker image
-----------------------
One easy way to get a collection of rebar3, Erlang 19 and the udon code together into a run time environment, is to use the included Dockerfile.  To build a docker image, you can execute the following commands:

    $ docker build -t <USERNAME>/udon .
    $ docker run -it <USERNAME>/udon bash
    root@de8b68cfa169:/# cd /root/udon
    root@de8b68cfa169:~/udon# rebar3 release
    root@de8b68cfa169:~/udon# make console
    
The hash value of your Docker container after `root@` may not match the example here. That's ok.

Build
-----

    rebar3 release

Test
----

    rebar3 ct

Run
---

    rebar3 run

Try
---

    1> udon:ping().
    {pong,753586781748746817198774991869333432010090217472}

Quit
----

    2> q().

Play with Clustering
--------------------

Build 3 releases that can run on the same machine:

    make devrel

Start them in different consoles:

    make dev1-console
    make dev2-console
    make dev3-console

join 2 nodes to the first one:

    make devrel-join

check the status of the cluster:

    make devrel-status

you should see something like this:

    ================================= Membership ==================================
    Status     Ring    Pending    Node
    -------------------------------------------------------------------------------
    joining     0.0%      --      'udon2@127.0.0.1'
    joining     0.0%      --      'udon3@127.0.0.1'
    valid     100.0%      --      'udon1@127.0.0.1'
    -------------------------------------------------------------------------------
    Valid:1 / Leaving:0 / Exiting:0 / Joining:2 / Down:0

it should say that 3 nodes are joining, now check the cluster plan:

    make devrel-cluster-plan

it should display the cluster plan, now we can commit the plan:

    make devrel-cluster-commit

check the status of the cluster again:

    make devrel-status

you could see the vnodes transfering:

    ================================= Membership ==================================
    Status     Ring    Pending    Node
    -------------------------------------------------------------------------------
    valid      75.0%     25.0%    'udon1@127.0.0.1'
    valid       9.4%     25.0%    'udon2@127.0.0.1'
    valid       7.8%     25.0%    'udon3@127.0.0.1'
    -------------------------------------------------------------------------------
    Valid:3 / Leaving:0 / Exiting:0 / Joining:0 / Down:0

at some point you should see something like this:

    ================================= Membership ==================================
    Status     Ring    Pending    Node
    -------------------------------------------------------------------------------
    valid      33.3%      --      'udon1@127.0.0.1'
    valid      33.3%      --      'udon2@127.0.0.1'
    valid      33.3%      --      'udon3@127.0.0.1'
    -------------------------------------------------------------------------------
    Valid:3 / Leaving:0 / Exiting:0 / Joining:0 / Down:0

when you are bored you can stop them:

    make devrel-stop

[1]: http://www.erlang-factory.com/india2017/
