@def title = "frstore: R interface to Google Firestore Database"
@def author = "Umair Durrani"
@def date = "2025-08-21"
@def tags = ["Analytics", "R", "APIs", "Firestore", "Google"]
@def short_text = ""
@def img_src = "/assets/images/frstore.png"

@def rss_pubdate = Date(2025, 08, 21)

~~~

{{ blog_header "R interface to <br> Firestore <br> Database" "/assets/PresageLogo.png" }}

Firestore is a Google Cloud NoSQL database that is used to power internal tooling and applications at Presage. Since there is no official support for interacting with Firestore in the R programming language, we developed the <a href="https://github.com/Presage-Group/frstore"><code>frstore</code></a> package that enables the Create, Read, Update, and Delete (CRUD) database operations on Firestore databases using R. This open-source package is available on GitHub.  

<br>
<br>

<a href="https://github.com/Presage-Group/frstore"><code>frstore</code></a> provides these functions for the CRUD operations:  

<br>
<br>

<table style="border-collapse: separate; border-spacing: 20px 10px;">
  <tr>
    <th style="text-align:left;">Operation</th>
    <th style="text-align:left;">Functions</th>
  </tr>
  <tr>
    <td>Create</td>
    <td><code>frstore_create_document</code></td>
  </tr>
  <tr>
    <td>Read</td>
    <td><code>frstore_get</code>; <code>frstore_run_query</code></td>
  </tr>
  <tr>
    <td>Update</td>
    <td><code>frstore_patch</code></td>
  </tr>
  <tr>
    <td>Delete</td>
    <td><code>frstore_delete</code></td>
  </tr>
</table>

<br>

See the <a href="https://github.com/Presage-Group/frstore"><code>frstore</code></a> GitHub repo for more details.

{{ blog_footer }}

~~~