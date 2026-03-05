ExUnit.start(exclude: [:e2e, :integration])
Mox.defmock(Levicon.Worker.MockAdapterMox, for: Levicon.Worker.Adapter)
