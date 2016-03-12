# How to add an organization

Create a JSON file in the [orgs](../orgs) directory with the following
properties:

- name (string)
- url (string)
- tags (array of strings)
- latitude (number)
- longitude (number)

The filename must be a
[slug](https://en.wikipedia.org/wiki/Semantic_URL#Slug) of the
organization name and end with the `.json` suffix.

See [How to find the coordinates of an
organization](how-to-find-the-coordinates-of-an-organization.md) for
the latitude and longitude properties.


## Example

Filename: `savoir-faire-linux.json`

Content:

```
{
  "name": "Savoir-faire Linux",
  "url": "http://savoirfairelinux.com",
  "tags": ["c++", "java", "python", "php", "linux", "django", "node.js"],
  "latitude": 45.53431,
  "longitude": -73.62074
}
```
