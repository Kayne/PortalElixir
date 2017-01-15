defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """
  
  defstruct [:left, :right]

  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer( left, right, data ) do
    for item <- data do
      Portal.Door.push( left, item )
    end

    # Returns a portal struct we will use next
    %Portal{ left: left, right: right }
  end

  @doc """
  Pushes data to the right in the given `portal`.
  """
  def push_right( portal ) do
    # See if can pop data from left. If so, push the
    # popped data to the right. Otherwise, do nothnig.
    case Portal.Door.pop( portal.left ) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push( portal.right, h )
    end

    # Let's return the portal itself
    portal
  end
end
