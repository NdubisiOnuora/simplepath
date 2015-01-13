==========
simplepath
==========

.. image:: https://badge.fury.io/py/simplepath.png
    :target: http://badge.fury.io/py/simplepath

.. image:: https://travis-ci.org/miki725/simplepath.png?branch=master
        :target: https://travis-ci.org/miki725/simplepath

.. image:: https://pypip.in/d/simplepath/badge.png
        :target: https://pypi.python.org/pypi/simplepath

``simplepath`` is a library for data-structure lookups
using a super simple expressions with performance in mind.
*"simplepath"* is a word play on some other ``*path`` technologies
such as ``xpath``, ``jsonpath``, ``jpath``, etc.

* Free software: MIT license
* GitHub: https://github.com/dealertrack/simplepath
* Documentation: https://simplepath.readthedocs.org.

Inspiration
-----------

The inspiration for ``simplepath`` was performance. Many other
libraries focus a making single lookups however fall short when
lots of data needs to be looked up.

For example if a dictionary with some structure needs to be converted
into another dictionary with a different structure, a simple and
configurable way of doing that might be to define a configration
dictionary where the keys will be the keys of the output dictionary
and values will be lookup expressions to get appropriate data::

    {
        "greetings": "foo.greeting",
        "planet": "foo.[0].planet",
        ...
    }

The above approach is easy to implement however is not very performant
since on each lookup, the lookup expression will have to be evaluated.
At dealertrack, we needed to do something similar at some point and
using `jsonpath-rw <https://pypi.python.org/pypi/jsonpath-rw>`_
it would sometimes take 15 seconds to map dictionaries with only
a couple of hundred expressions. Upon some investigation, most of the
time was being spent in `ply <https://pypi.python.org/pypi/ply>`_.
Unfortinately we did not find another comparable library which
accomplished everything we neededed and satisfied our performance
requirements so ``simplepath`` was born.

Installing
----------

You can install ``simplepath`` using pip::

    $ pip install simplepath

Quick Guide
-----------

Here is a quick example. For more documentation, please
make sure to check out our `docs <https://simplepath.readthedocs.org>`_.

::

    from simplepath.mapper import Mapper

    class MyMapper(Mapper):
        config = {
            'greetings': 'example.greetings',
            'to': 'example.planets.<find:planet=Earth>.residents',
        }

    data = {
        'example': {
            'greetings': 'Hello',
            'planets': [
                {
                    'planet': 'Mars',
                    'residents': 'marsians',
                },
                {
                    'planet': 'Earth',
                    'residents': 'people',
                },
                {
                    'planet': 'Space',
                    'residents': 'aliens',
                },
            ]
        }
    }

    MyMapper.map_data(data) == {
        'greetings': 'Hello',
        'to': 'people',
    }

Testing
-------

To run the tests you need to install testing requirements first::

    $ make install

Then to run tests, you can use ``nosetests`` or simply use Makefile command::

    $ nosetests -sv
    # or
    $ make test