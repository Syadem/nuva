# frozen_string_literal: true

require 'open3'
require 'pathname'
require 'fileutils'
require 'time'
require 'redcarpet'

root = Pathname.new(__dir__).parent
release_tag = ARGV.fetch(0, 'HEAD')

git = lambda do |*args|
  output, error, status = Open3.capture3('git', '-C', root.to_s, *args)
  raise "Git command failed: #{error.strip}" unless status.success?

  output.strip
end

# Limit history to versions reachable from the release being published.
tags = git.call('tag', '--merged', release_tag, '--sort=-version:refname', '--sort=-creatordate').lines.map(&:strip)
if tags.include?(release_tag)
  tags.delete(release_tag)
  tags.unshift(release_tag)
end

markdown = +"# Nuva changelog\n\n"
markdown << "No tagged versions yet.\n" if tags.empty?

tags.each_with_index do |tag, index|
  previous_tag = tags[index + 1]
  date = Time.parse(git.call('log', '-1', '--format=%aI', tag, '--')).strftime('%Y-%m-%d')
  author = git.call('log', '-1', '--format=%an', tag, '--')
  range = previous_tag ? "#{previous_tag}..#{tag}" : tag
  commits = git.call('log', '--format=%h - %s (%an)', range, '--').lines.map(&:strip)
  files = if previous_tag
    git.call('diff', '--name-status', previous_tag, tag, '--').lines.map(&:strip)
  else
    # The first version contains all files at that tag, never the working tree.
    git.call('ls-tree', '-r', '--name-only', tag).lines.map { |file| "A\t#{file.strip}" }
  end

  markdown << "## Version #{tag}\n\n"
  markdown << "**Date:** #{date}\n\n**Author:** #{author}\n\n"
  markdown << "### Changes\n\n"
  commits.each { |commit| markdown << "- #{commit}\n" }
  unless files.empty?
    markdown << "\n### Files\n\n"
    files.each do |file|
      status, *paths = file.split("\t")
      markdown << "- **#{status}**: #{paths.map { |name| "`#{name}`" }.join(' → ')}\n"
    end
  end
  markdown << "\n"
end

renderer = Redcarpet::Render::HTML.new(filter_html: true)
body = Redcarpet::Markdown.new(renderer, autolink: true).render(markdown)
body = body.gsub(/<h3>Files<\/h3>\s*(<ul>.*?<\/ul>)/m) do
  "<details>\n<summary>Files</summary>\n#{Regexp.last_match(1)}\n</details>"
end
html = <<~HTML
  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Nuva changelog</title>
      <style>
        body { margin: 0; color: #172033; background: #f5f7fa; font: 16px/1.6 system-ui, sans-serif; }
        main { max-width: 960px; margin: 0 auto; padding: 32px 24px; }
        h2 { border-top: 1px solid #ccd3dd; padding-top: 24px; margin-top: 32px; }
        h3 { font-size: 1em; }
        a { color: #2459a6; }
        li { overflow-wrap: anywhere; }
        code { font-size: .9em; }
        details { margin: 24px 0; }
        summary { cursor: pointer; font-weight: 600; }
      </style>
    </head>
    <body><main>
      #{body}
    </main></body>
  </html>
HTML

output_dir = root.join('build')
FileUtils.mkdir_p(output_dir)
File.write(output_dir.join('changelog.md'), markdown)
File.write(output_dir.join('changelog.html'), html)
File.write(output_dir.join('index.html'), html)
puts "Changelog generated in #{output_dir} (#{tags.length} versions)"
