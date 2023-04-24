defmodule Xmerl.XmlElement do
  @moduledoc """
  Extract the xmerl.hrl#xmlElement record into an elixir record

  Format:
  	%% XML Element
  	%% content = [#xmlElement()|#xmlText()|#xmlPI()|#xmlComment()|#xmlDecl()]
  	-record(xmlElement,{
  		name,											% atom()
  		expanded_name = [],				% string() | {URI,Local} | {"xmlns",Local}
  		nsinfo = [],	        		% {Prefix, Local} | []
  		namespace=#xmlNamespace{},
  		parents = [],							% [{atom(),integer()}]
  		pos,											% integer()
  		attributes = [],					% [#xmlAttribute()]
  		content = [],
  		language = "",						% string()
  		xmlbase="",       		    % string() XML Base path, for relative URI:s
  		elementdef=undeclared 		% atom(), one of [undeclared | prolog | external | element]
  	}).
  """
  require Record
  Record.defrecord(:xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl"))

  @type xmlElement :: record(:xmlElement, name: String.t())
end
