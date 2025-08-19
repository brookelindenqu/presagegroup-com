function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

@delay function hfun_recent_posts(m::Vector{String})
    @assert length(m) == 1 "only one argument allowed for recent posts (the number of recent posts to pull)"
    n = parse(Int64, m[1])
    list = readdir("posts")
    filter!(f -> endswith(f, ".md") && f != "index.md", list)
    posts = []
    df = DateFormat("yyyy-mm-dd")
    for (k, post) in enumerate(list)
        fi = "posts/" * splitext(post)[1]
        title = pagevar(fi, :title)
        datestr = pagevar(fi, :date)
        tags = pagevar(fi, :tags; default = [""])
        author = pagevar(fi, :author)
        short_text = pagevar(fi, :short_text)
        img_path = pagevar(fi, :img_src)
        if !isnothing(datestr)
            date = Date(datestr, df)
            push!(posts, (
              title=title, 
              link=fi, 
              date=date, 
              tags=tags, 
              author=author,
              short_text=short_text,
              img_path=img_path
            ))
        end
    end

    html = """
    <section class="bg-white">
      <div class="w-full px-5 py-6 mx-auto space-y-5 sm:py-8 md:py-12 sm:space-y-8 md:space-y-16 max-w-7xl">
    """

    # pull all posts if n <= 0
    n = n >= 0 ? n : length(posts) + 1

    eles = sort(posts, by=x -> x.date, rev=true)
    fp = eles[1]

    html *= featured_post(fp.title, fp.link, fp.date, fp.short_text, fp.author; tags = fp.tags)

    html *= """\n
      <div class="flex grid grid-cols-12 pb-10 sm:px-5 gap-x-8 gap-y-16">
    """

    for ele in eles[2:min(length(posts), n)]
        html *= grid_post(ele.title, ele.link, ele.date, ele.short_text, ele.author; tags = ele.tags, img = ele.img_path)
    end

    html *= """
        </div>
      </div>
    </section>
    """

    return html
end

@delay function hfun_all_posts()
    return hfun_recent_posts(["-1"])
end

function featured_post(title, link, date, short_text = "test", author = "Presage Group"; length = nothing, tags = nothing, img = nothing)
  if isnothing(tags) 
    tag_html = ""
  else
    tag_html = reduce(*, format_tag.(tags))
  end

  if isnothing(length)
    length_html = "5 min. read"
  else
    length_html = length
  end

  if isnothing(img)
    img_src = "/assets/Presage_Logo_noTXT.svg"
  else 
    img_src = img
  end
  
  html = """
  <div class="flex flex-col items-center sm:px-5 md:flex-row">
      <div class="w-full md:w-1/2">
          <a href="/$link/" class="block">
              <img class="object-cover w-full h-full rounded-lg max-h-64 sm:max-h-96" src="$img_src">
          </a>
      </div>
      <div class="flex flex-col items-start justify-center w-full h-full py-6 mb-6 md:mb-0 md:w-1/2">
          <div class="flex flex-col items-start justify-center h-full space-y-1 transform md:pl-10 lg:pl-16 md:space-y-2">
              
              <h1 class="text-4xl font-bold leading-none mb-0 lg:text-5xl xl:text-6xl">
                <a href="/$link/">$title.</a>
              </h1>

              <p class="text-sm text-gray-500">$short_text</p>

              <div class="flex flex-col w-full md:flex-row">
                $tag_html
              </div>

              <p class="pt-2 text-sm font-medium">by <a href="/pages/team.html" class="mr-1 underline">$author</a> · <span class="mx-1">$date</span> · <span class="mx-1 text-gray-600">$length_html</span></p>
          </div>
      </div>
  </div>
  """
  return html
end

function grid_post(title, link, date, short_text = "test", author = "Presage Group"; length = nothing, tags = nothing, img = nothing)
  
  if isnothing(tags) 
    tag_html = ""
  else
    tag_html = reduce(*, format_tag.(tags))
  end

  if isnothing(length)
    length_html = "5 min. read"
  else
    length_html = length
  end

  if isnothing(img)
    img_src = "/assets/Presage_Logo_noTXT.svg"
  else 
    img_src = img
  end

  html = """
  <div class="flex flex-col items-start col-span-12 space-y-3 sm:col-span-6 xl:col-span-4">
      <a href="/$link/" class="block">
          <img class="object-cover w-full mb-2 overflow-hidden rounded-lg shadow-sm max-h-56" src="$img_src">
      </a>
      


      <div class="flex flex-col w-full md:flex-row">
        $tag_html
      </div>

      <h2 class="text-lg font-bold sm:text-xl md:text-2xl"><a href="/$link/">$title</a></h2>
      <p class="text-sm text-gray-500">$short_text</p>
      <p class="pt-2 text-xs font-medium"><a href="#_" class="mr-1 underline">$author</a> · <span class="mx-1">$date</span> · <span class="mx-1 text-gray-600">$length_html</span></p>
  </div>
  """
  return html
end

function format_tag(tag_name)
  html = """\n
  <div class="bg-$(tag_color(tag_name)) flex items-center px-3 py-1.5 leading-none rounded-full text-xs font-medium uppercase text-white inline-block">
    <span>$tag_name</span>
  </div>\n
  """
  return html
end

function tag_color(string)
  selected = Int(hash(string) % 12)
  return tag_color_lookup[selected]
end

const tag_color_lookup = Dict{Int64,String}(
  0 => "teal-500",
  1 => "purple-500",
  2 => "blue-500",
  3 => "red-500",
  4 => "orange-500",
  5 => "emerald-500",
  6 => "sky-500",
  7 => "violet-500",
  8 => "rose-500",
  9 => "amber-500",
  10 => "lime-500",
  11 => "indigo-500"
)
  
@delay function hfun_blog_header(title_img)
  html = """
  <section class="flex items-center justify-center py-10 text-white bg-white sm:py-16 md:py-24 lg:py-32">
    <div class="relative max-w-3xl px-10 text-center text-white auto lg:px-0">
        <div class="flex flex-col w-full md:flex-row">

            <!-- Top Text -->
            <div class="flex justify-between">
                <h1 class="relative flex flex-col text-6xl font-extrabold text-left text-black">
                    $(title_img[1])
                </h1>
            </div>
            <!-- Right Image -->
            <div class="relative top-0 right-0 h-64 mt-12 md:-mt-16 md:absolute md:h-96">
                <img src="$(title_img[2])" class="object-cover mt-3 mr-5 h-80 lg:h-72 rounded-md">
            </div>
        </div>

        <!-- Separator -->
        <div class="my-16 border-b border-gray-300 lg:my-24"></div>

        <!-- Bottom Text -->
        <h2 class="text-left text-gray-500 xl:text-xl">
  """
  return html
end

function hfun_blog_footer()
  html =  """
      </h2>
    </div>
  </section>
  """
  return html
end

function hfun_small_card(args)
  name = args[1]
  photo = args[2]
  title = args[3]
  bio = args[4]
  
  links = args[5:end]

  link_html = """
  <div class="col-12 col-md-6 col-lg-4">
  <div class="card border-0 shadow-lg pt-5 my-5 position-relative">
    <div class="card-body p-4">
      <div class="member-profile position-absolute w-100 text-center">
        <img
          class="rounded-circle mx-auto d-inline-block shadow-sm"
          src=$photo
          alt=""
        />
      </div>
      <div class="card-text pt-1">
        <h5 class="member-name mb-0 text-center text-primary font-weight-bold">
          $name
        </h5>
        <div class="mb-3 text-center">
          $title
        </div>
        <div>
          $bio
        </div>
      </div>
    </div>
    <div class="card-footer theme-bg-primary border-0 text-center">
      <ul class="social-list list-inline mb-0 mx-auto">
  """

  for link in 1:2:length(links)
    link_html *= profile_link(links[link], links[link+1])
  end
  
  link_html *= """
        </ul>
      </div>
    </div>
  </div>
  """
  return link_html
end

function profile_link(type, link)
  html = """
  <li class="list-inline-item">
    <a class="text-dark" href="$link">
  """

  html *= icons[type]

  return html
end

const icons = Dict{String,String}(
  "linkedin" => """
  <svg class="svg-inline--fa fa-linkedin-in fa-w-14 fa-fw"
            aria-hidden="true"
            focusable="false"
            data-prefix="fab"
            data-icon="linkedin-in"
            role="img"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 448 512"
            data-fa-i2svg=""
        >
            <path
                fill="currentColor"
                d="M100.28 448H7.4V148.9h92.88zM53.79 108.1C24.09 108.1 0 83.5 0 53.8a53.79 53.79 0 0 1 107.58 0c0 29.7-24.1 54.3-53.79 54.3zM447.9 448h-92.68V302.4c0-34.7-.7-79.2-48.29-79.2-48.29 0-55.69 37.7-55.69 76.7V448h-92.78V148.9h89.08v40.8h1.3c12.4-23.5 42.69-48.3 87.88-48.3 94 0 111.28 61.9 111.28 142.3V448z"
            ></path></svg
        ><!-- <i class="fab fa-linkedin-in fa-fw"></i> Font Awesome fontawesome.com --></a
    >
  </li>    
  """, 
  "google scholar" => """
  <svg
      xmlns="http://www.w3.org/2000/svg"
      width="16"
      height="16"
      fill="currentColor"
      class="bi bi-mortarboard-fill"
      viewBox="0 0 16 16"
  >
      <path
          d="M8.211 2.047a.5.5 0 0 0-.422 0l-7.5 3.5a.5.5 0 0 0 .025.917l7.5 3a.5.5 0 0 0 .372 0L14 7.14V13a1 1 0 0 0-1 1v2h3v-2a1 1 0 0 0-1-1V6.739l.686-.275a.5.5 0 0 0 .025-.917z"
      />
      <path
          d="M4.176 9.032a.5.5 0 0 0-.656.327l-.5 1.7a.5.5 0 0 0 .294.605l4.5 1.8a.5.5 0 0 0 .372 0l4.5-1.8a.5.5 0 0 0 .294-.605l-.5-1.7a.5.5 0 0 0-.656-.327L8 10.466z"
      /></svg
    ><!-- <i class="fab fa-linkedin-in fa-fw"></i> Font Awesome fontawesome.com --></a>
  </li>
  """,
  "x" => """
  <svg
      class="svg-inline--fa fa-twitter fa-w-16 fa-fw"
      aria-hidden="true"
      focusable="false"
      data-prefix="fab"
      data-icon="twitter"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 512 512"
      data-fa-i2svg=""
  >
      <path
          fill="currentColor"
          d="M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z"
      ></path></svg
  ><!-- <i class="fab fa-twitter fa-fw"></i> Font Awesome fontawesome.com --></a>
  </li>
  """,
  "github" => """
  <svg
      class="svg-inline--fa fa-github fa-w-16 fa-fw"
      aria-hidden="true"
      focusable="false"
      data-prefix="fab"
      data-icon="github"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 496 512"
      data-fa-i2svg=""
  >
      <path
          fill="currentColor"
          d="M165.9 397.4c0 2-2.3 3.6-5.2 3.6-3.3.3-5.6-1.3-5.6-3.6 0-2 2.3-3.6 5.2-3.6 3-.3 5.6 1.3 5.6 3.6zm-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9 2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5.3-6.2 2.3zm44.2-1.7c-2.9.7-4.9 2.6-4.6 4.9.3 2 2.9 3.3 5.9 2.6 2.9-.7 4.9-2.6 4.6-4.6-.3-1.9-3-3.2-5.9-2.9zM244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2 12.8 2.3 17.3-5.6 17.3-12.1 0-6.2-.3-40.4-.3-61.4 0 0-70 15-84.7-29.8 0 0-11.4-29.1-27.8-36.6 0 0-22.9-15.7 1.6-15.4 0 0 24.9 2 38.6 25.8 21.9 38.6 58.6 27.5 72.9 20.9 2.3-16 8.8-27.1 16-33.7-55.9-6.2-112.3-14.3-112.3-110.5 0-27.5 7.6-41.3 23.6-58.9-2.6-6.5-11.1-33.3 2.6-67.9 20.9-6.5 69 27 69 27 20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27 13.7 34.7 5.2 61.4 2.6 67.9 16 17.7 25.8 31.5 25.8 58.9 0 96.5-58.9 104.2-114.8 110.5 9.2 7.9 17 22.9 17 46.4 0 33.7-.3 75.4-.3 83.6 0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252 496 113.3 383.5 8 244.8 8zM97.2 352.9c-1.3 1-1 3.3.7 5.2 1.6 1.6 3.9 2.3 5.2 1 1.3-1 1-3.3-.7-5.2-1.6-1.6-3.9-2.3-5.2-1zm-10.8-8.1c-.7 1.3.3 2.9 2.3 3.9 1.6 1 3.6.7 4.3-.7.7-1.3-.3-2.9-2.3-3.9-2-.6-3.6-.3-4.3.7zm32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2 2.3 2.3 5.2 2.6 6.5 1 1.3-1.3.7-4.3-1.3-6.2-2.2-2.3-5.2-2.6-6.5-1zm-11.4-14.7c-1.6 1-1.6 3.6 0 5.9 1.6 2.3 4.3 3.3 5.6 2.3 1.6-1.3 1.6-3.9 0-6.2-1.4-2.3-4-3.3-5.6-2z"
      ></path></svg
  ><!-- <i class="fab fa-github fa-fw"></i> Font Awesome fontawesome.com --></a>
  </li>
  """,
  "email" => """
  <svg
      xmlns="http://www.w3.org/2000/svg"
      width="18"
      height="18"
      fill="currentColor"
      class="bi bi-envelope"
      viewBox="0 0 16 16"
  >
      <path
          d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1zm13 2.383-4.708 2.825L15 11.105zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741M1 11.105l4.708-2.897L1 5.383z"
      ></path></svg
  ><!-- <i class="fab fa-linkedin-in fa-fw"></i> Font Awesome fontawesome.com --></a>
  </li>
  """)               
                        
                            
                                
                            