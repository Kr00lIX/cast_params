defmodule CastParams.Param do
  @enforce_keys [:name, :type]
  defstruct [name: nil, type: nil, required: false]

  @types [:boolean, :integer]
  @required_to_type %{
    boolean!: :boolean,
    integer!: :integer
  }
  
  @required_types Map.keys(@required_to_type)

  def parse(name, raw_type) when raw_type in @required_types do
    %__MODULE__{name: name, type: @required_to_type[raw_type], required: true}
  end

  def parse(name, raw_type) when raw_type in @types do
    %__MODULE__{name: name, type: raw_type}
  end
end