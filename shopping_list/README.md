# Shopping List

### Intro to GenServer

```
% iex -S mix
...

> {:ok, pid} = ShoppingList.start_link(["apple"])
{:ok, #PID<0.139.0>}

> Process.alive?(pid)
true

> ShoppingList.add(pid, "eggs")
:ok

> ShoppingList.add(pid, "milk")
:ok

> ShoppingList.add(pid, "cheese")
:ok

> ShoppingList.view(pid)
["cheese", "milk", "eggs", "apple"]
iex(6)> ShoppingList.remove(pid, "cheese")
:ok

> ShoppingList.view(pid)
["milk", "eggs", "apple"]

> ShoppingList.stop(pid)
We are all done shopping.
["milk", "eggs", "apple"]
:ok

> Process.alive?(pid)
false
```
