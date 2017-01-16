defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """
  
  use Application
  
  defstruct [:left, :right]

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Portal.Door, [])
    ]

    opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  shoots a new door with the given `color`
  """
  def shoot(color) do
    import Supervisor.Spec
    Supervisor.start_child(Portal.Supervisor, worker(Portal.Door, [color], [id: color]) )
  end

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
    push( portal.left, portal.right )

    # Let's return the portal itself
    portal
  end

  @doc """
  Pushes data to the left in the given `portal`.
  """
  def push_left( portal ) do
    push( portal.right, portal.left )

    portal
  end

  defp push( from, to ) do
    case Portal.Door.pop( from ) do
      :error   -> :ok
      {:ok, h} -> Portal.Door.push( to, h )
    end
  end

end

defimpl Inspect, for: Portal do
  def inspect(%Portal{ left: left, right: right }, _) do
    left_door = inspect( left )
    right_door = inspect( right )

    left_data = inspect( Enum.reverse( Portal.Door.get( left ) ) )
    right_data = inspect( Portal.Door.get( right ) )

    max = max(String.length( left_door ), String.length( left_data ) )

    """
    #Portal<
      #{ String.rjust( left_door, max ) } <=> #{ right_door }
      #{ String.rjust( left_data, max ) } <=> #{ right_data }
    """
  end
end
