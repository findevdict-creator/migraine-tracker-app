# watch_protocol

The messages the phone app and the watch apps exchange, shared by the
phone (`lib/features/watch/`) and the Wear OS app (`wear/`). The watchOS
app (phase 28) speaks the same JSON from Swift.

- The phone sends a `WatchState` as the application context: the level
  strings already rendered in the phone's language, the level colour, the
  running attack, the button labels and the ids of the commands it has
  applied.
- The watch sends `WatchCommand`s (start, stop, intensity) as messages.
  Each command has an id and the time it was made on the watch, so a
  command queued while the phone was away still lands at the right time
  and is applied once.
- `CommandQueue` keeps the watch's unsent commands until the phone
  acknowledges them; `WatchView` shows the phone's state with the pending
  commands applied on top, so the watch responds at once offline.
- `CommandLedger` remembers which ids the phone already applied.

Both sides wrap the JSON in a single string under `WatchWire.payloadKey`,
because the Wear OS data layer only carries flat maps.
