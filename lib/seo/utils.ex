defmodule SEO.Utils do
  @moduledoc false

  use Phoenix.Component

  attr(:property, :string, required: true)
  attr(:content, :any, required: true, doc: "Either a string representing a URI, or a URI")

  def url(assigns) do
    case assigns[:content] do
      %URI{} ->
        ~H"""
        <meta property={@property} content={"#{@content}"} />
        """

      url when is_binary(url) ->
        ~H"""
        <meta property={@property} content={@content} />
        """
    end
  end

  def format_date(%Date{} = date), do: Date.to_iso8601(date)
  def format_date(%NaiveDateTime{} = ndt), do: NaiveDateTime.to_iso8601(ndt)
  def format_date(%DateTime{} = dt), do: DateTime.to_iso8601(dt)

  def truncate(text, length \\ 200) do
    if String.length(text) <= length do
      text
    else
      String.slice(text, 0..length)
    end
    |> String.trim()
  end

  def to_iso8601(%NaiveDateTime{} = ndt), do: NaiveDateTime.to_iso8601(ndt)
  def to_iso8601(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
  def to_iso8601(%Date{} = d), do: Date.to_iso8601(d)

  def merge_defaults(mod, attrs, nil), do: struct(mod, to_map(attrs))
  def merge_defaults(mod, attrs, []), do: struct(mod, to_map(attrs))

  def merge_defaults(mod, attrs, defaults) do
    struct(mod, Map.merge(to_map(defaults), to_map(attrs)))
  end

  def to_map(nil), do: %{}
  def to_map([]), do: %{}
  def to_map(x) when is_struct(x), do: Map.from_struct(x)
  def to_map(x) when is_list(x), do: Enum.into(x, %{})
  def to_map(x) when is_map(x), do: x
end
