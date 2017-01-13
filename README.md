# EzWadl

The EzWadl gem provides easy access to the resources defined by a WADL. Note that EzWadl also supports generative URIs (see note below for more information).

## Usage

### Loading a WADL

Use EzWadl::Parser.parse to load a WADL. This returns an array of EzWadl::Resource, one for each top-level resources tag defined in the WADL.

Example:

```ruby
resources = EzWadl::Parser.parse('path_to_wadl_file')
```

You can also pass a block to modify the returned resources.

Example:

```ruby
EzWadl::Parser.parse('path_to_wadl_file') do  |rs| 
  rs.first.path = 'https://mycustompath.com'
end
```

### Accessing a Specific URI

EzWadl::Resource provides a handful of useful instance methods to help you navigate to the desired URI. 

* httpmethods: Returns an Array of Strings of the HTTP verbs that can be used against this resource
* uri: Returns a URI object for this resource
* path: Returns a String of the path segment for this resource
* paths: Returns an Array containing an Array for each child resource consisting of the URI String of the child resource as well as the Symbol for the function that returns the EzWadl::Resource for the child resource.

Example:

test.wadl ([source](http://www.nurkiewicz.com/2012/01/gentle-introduction-to-wadl-in-java.html))
```xml
<application xmlns="http://wadl.dev.java.net/2009/02">
    <resources base="http://example.com/api">
        <resource path="books">
            <method name="GET"/>
            <resource path="{bookId}">
                <param required="true" style="template" name="bookId"/>
                <method name="GET"/>
            </resource>
        </resource>
    </resources>
</application>
```

```ruby
# Parse the WADL file
resources = EzWadl::Parser.parse('test.wadl')

# See what paths/resources are available
resources.first.paths # [["books", :books]]

# Access the "books" resource
resources.first.books

# See what nested paths/resources are available from "books"
resources.first.books.paths # [["{bookId}", :bookId]]

# Access the nested "bookId" resource
resources.first.books.bookId
```

### Performing Actions Against a URI

Once you have the EzWadl::Resource for the URI you want to use, call the function named after the desired HTTP verb, ie. resource.get. **NOTE: Only GET requests have been tested**.

Each verb function takes a Hash argument of the following structure:

```ruby
{query:
  { param1: value1, param2: value2, ... }
}
```

### A Note About Generative URIs

Generative URIs are URIs that contain placeholders, ie. http://example.com/api/v1/examples/{example_id}

When calling the verb methods described in the previous section, any parameters in the query hash that match URI placeholders are substituted into the URI before submission.
