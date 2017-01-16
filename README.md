# PortalElixir

Implemented Portal-like behaviour in Elixir by tutorial authored by José Valim on [How I start?](http://howistart.org/posts/elixir/1) website.

## Summary

It's simple implementation of Portal-like objects, which can send data to each other. Additionaly there is a Supervisor which will restart terminated portals to make sure data can be translated (but with data loss).

## Usage

```elixir

iex> Portal.shoot(:orange)
{:ok, #PID<0.72.0>}
iex> Portal.shoot(:blue)
{:ok, #PID<0.74.0>}
iex> portal = Portal.transfer(:orange, :blue, [1, 2, 3, 4])
#Portal<
       :orange <=> :blue
  [1, 2, 3, 4] <=> []
>

iex> Portal.push_right(portal)
#Portal<
    :orange <=> :blue
  [1, 2, 3] <=> [4]
>


iex> Portal.push_left(portal)
#Portal<
    :orange <=> :blue
  [1, 2, 3, 4] <=> []
>
```