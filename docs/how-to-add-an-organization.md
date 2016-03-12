To add an organization, create a JSON file in the [orgs](../orgs)
directory with the following properties:

- name (string)
- url (string)
- tags (array of strings)
- latitude (number)
- longitude (number)

Example:

```
{
  "name": "Savoir-faire Linux",
  "url": "http://savoirfairelinux.com",
  "tags": ["c++", "java", "python", "php", "linux", "django", "node.js"],
  "latitude": 45.53431,
  "longitude": -73.62074
}
```
