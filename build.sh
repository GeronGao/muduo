#!/bin/sh
#!/usr/bin/env bash
# ******************************************************
# DESC    : script for muduo install
# AUTHOR  : Alex Stocks, Geron
# VERSION : 1.0
# LICENCE : LGPL V3
# EMAIL   : alexstocks@foxmail.com
# MOD     : 2016-05-13 02:01,2019-06-23
# FILE    : load.sh
# ******************************************************

#name="zookeeper"

base=muduo/base/tests/lib
net=muduo/net/tests/lib
contrib=contrib
build=build

usage() {
    echo "Usage: $0 build [base | net | all |install] # in default, build all."
    echo "       $0 clean [base | net | all |install] # in default, clean all."
}



build() {
    target=$1
    echo "build " $target
    # make build dir.
    if [ ! -d "build" ]; then
        mkdir -p $build
    fi
    if [ ! -d "bin" ]; then
        mkdir -p $build/bin
    fi
    if [ ! -d "lib" ]; then
        mkdir -p $build/lib
    fi
    case C"$target" in
        Cbase)
            cd muduo/base/tests  && make -f makefile && cd -
            cp $base/libmuduo_base.a  $build/lib
            ;;
        Cnet)
            cd muduo/net/tests  && make -f makefile && cd -
            cp $net/libmuduo.a  $build/lib
            ;;
        Cinstall)
            sudo ln -sbv $build/lib /usr/lib/muduo
            sudo mkdir -p /usr/include/muduo
            sudo ln -sbv $build/muduo/base /usr/include/muduo/base
            sudo ln -sbv $build/muduo/net /usr/include/muduo/net
            ;;
        C*)
            cd muduo/base/tests  && make -f makefile && cd -
            cp $base/libmuduo_base.a  $build/lib
            cd muduo/net/tests  && make -f makefile && cd -
            cp $net/libmuduo.a  $build/lib
            ;;
    esac
}

clean() {
    target=$1
    echo "clean " $target

    case C"$target" in
        Cbase)
            cd muduo/base/tests  && make -f makefile clean && cd -
            rm -rf $build/lib/libmuduo_base.a
            ;;
        Cnet)
            cd muduo/net/tests  && make -f makefile clean && cd -
            rm -rf $build/lib/libmuduo.a
            ;;
        Cinstall)
            if [ -d /usr/lib/muduo ]; then
                sudo rm /usr/lib/muduo
            fi
            if [ -d /usr/include/muduo ]; then
                sudo rm -r /usr/include/muduo
            fi            
            ;;
        C*)
            cd muduo/base/tests  && make -f makefile clean && cd -
            cd muduo/net/tests   && make -f makefile clean && cd -
            cd $contrib/hiredis  && make -f makefile clean && cd -
            rm -rf $build
            ;;
    esac
}

opt=$1
target="all"
if [ $# == 2 ]; then
	target=$2
fi

case C"$opt" in
    Cbuild)
        build $target
        ;;
    Cclean)
        clean $target
        ;;
    C*)
        usage
        ;;
esac

