# Sums of Products

An alternative to things you can do with Codable

## What's implemented

* The [generic representation](https://github.com/chriseidhof/swift-sums-of-products/blob/master/Sources/SOP/Describes.swift)
* Generic Algorithms
	* Converting (parsing) a JSON Object into a type: [FromJSON.swift](https://github.com/chriseidhof/swift-sums-of-products/blob/master/Sources/SOP/FromJSON.swift)
		* This has better error messages than Codable
	* [Pretty Printing](https://github.com/chriseidhof/swift-sums-of-products/blob/master/Sources/SOP/PrettyPrinting.swift) to a String (similar to dump):
	* [Generating XML](https://github.com/chriseidhof/swift-sums-of-products/blob/master/Sources/SOP/XML.swift)
* Code Generation
	* We can generate an enum and its generic representation


## TODO

* Write tests
* Implement code generation for structs
* Describe how to integrate code generation into your project

## Ideas

* Generic XML Parsing
* Generating HTML (pretty-printing), maybe even forms?
* Generating attributed strings
* Generating UIViews?
* Binary encoder/decoder
	* When we do this, we can hash the type to make sure we are encoding/decoding the same schema
* Generating random values
