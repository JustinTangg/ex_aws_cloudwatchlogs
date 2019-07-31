defmodule ExAws.CloudWatchLogsTest do
  use ExUnit.Case
  doctest ExAws.CloudWatchLogs

  test "greets the world" do
    assert ExAws.CloudWatchLogs.hello() == :world
  end
end
