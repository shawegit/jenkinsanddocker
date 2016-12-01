//Link to Boost 
//Define our Module name (prints at testing)
#define BOOST_TEST_MODULE "AddTwoNumbers"
//VERY IMPORTANT - include this last
#include <boost/test/unit_test.hpp>
#include "mylib.h"

BOOST_AUTO_TEST_SUITE(AddTwoNumbersSuite)

BOOST_AUTO_TEST_CASE(AddPositives)
{
	auto result = addTwoInts(0, 0);
	BOOST_CHECK_EQUAL(result, 0); 

	result = addTwoInts(10, 0);
	BOOST_CHECK_EQUAL(result, 10);

	result = addTwoInts(10, 20);
	BOOST_CHECK_EQUAL(result, 30);
}

BOOST_AUTO_TEST_CASE(AddNegatives)
{
	auto result = addTwoInts(-10, 0);
	BOOST_CHECK_EQUAL(result, -10);

	result = addTwoInts(-10, -20);
	BOOST_CHECK_EQUAL(result, -30);
}

BOOST_AUTO_TEST_CASE(AddMixed)
{
	auto result = addTwoInts(10, -20);
	BOOST_CHECK_EQUAL(result, -10);

	result = addTwoInts(-10, 20);
	BOOST_CHECK_EQUAL(result, 10);
}

BOOST_AUTO_TEST_SUITE_END()