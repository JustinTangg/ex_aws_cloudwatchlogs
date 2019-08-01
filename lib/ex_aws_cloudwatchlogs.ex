defmodule ExAws.CloudWatchLogs do
  @moduledoc """
  Documentation for ExAws.CloudWatchLogs.
  """

  # version of the AWS API
  @version "20140328"
  @namespace "Logs"

  @type tag :: %{key: binary, value: binary}

  @doc """
  Creates a log group with the specified name.

  You can create up to 5000 log groups per account.

  You must use the following guidelines when naming a log group:

  Log group names must be unique within a region for an AWS account.
  Log group names can be between 1 and 512 characters long.
  Log group names consist of the following characters: a-z, A-Z, 0-9, '_' (underscore), '-' (hyphen), '/' (forward slash), and '.' (period).
  If you associate a AWS Key Management Service (AWS KMS) customer master key (CMK) with the log group, ingested data is encrypted using the CMK. This association is stored as long as the data encrypted with the CMK is still within Amazon CloudWatch Logs. This enables Amazon CloudWatch Logs to decrypt this data whenever it is requested.

  If you attempt to associate a CMK with the log group but the CMK does not exist or the CMK is disabled, you will receive an InvalidParameterException error.
  """
  @type create_log_group_opts :: %{
          kms_key_id: binary,
          tags: [tag, ...]
        }
  @spec create_log_group(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  @spec create_log_group(log_group_name :: binary, create_log_group_opts) ::
          ExAws.Operation.JSON.t()
  def create_log_group(log_group_name, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{"logGroupName" => log_group_name})
    |> request(:create_log_group)
  end

  @spec create_log_stream(log_group_name :: binary, log_stream_name :: binary) ::
          ExAws.Operation.JSON.t()
  def create_log_stream(log_group_name, log_stream_name) do
    %{
      "logGroupName" => log_group_name,
      "logStreamName" => log_stream_name
    }
    |> request(:create_log_stream)
  end

  @doc """
  Lists the specified log groups. You can list all your log groups or filter the results by prefix. The results are ASCII-sorted by log group name.
  """
  @type describe_log_groups_opts :: %{
          log_group_name_prefix: binary,
          next_token: binary,
          limit: integer
        }
  @spec describe_log_groups() :: ExAws.Operation.JSON.t()
  @spec describe_log_groups(describe_log_groups_opts) :: ExAws.Operation.JSON.t()
  def describe_log_groups(opts \\ []) do
    opts
    |> camelize_keyword()
    |> request(:describe_log_groups)
  end

  @doc """
  Lists the log streams for the specified log group. You can list all the log streams or filter the results by prefix. You can also control how the results are ordered.

  This operation has a limit of five transactions per second, after which transactions are throttled.
  """
  @type describe_log_streams_opts :: %{
          log_stream_name_prefix: binary,
          order_by: binary,
          descending: boolean,
          next_token: binary,
          limit: integer
        }
  @spec describe_log_streams(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  @spec describe_log_streams(log_group_name :: binary, describe_log_streams_opts) ::
          ExAws.Operation.JSON.t()
  def describe_log_streams(log_group_name, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{"logGroupName" => log_group_name})
    |> request(:describe_log_streams)
  end

  ####################
  # Helper Functions #
  ####################

  defp request(data, action) do
    operation = action |> Atom.to_string() |> Macro.camelize()

    ExAws.Operation.JSON.new(
      :logs,
      %{
        data: data,
        headers: [
          {"x-amz-target", "#{@namespace}_#{@version}.#{operation}"},
          {"content-type", "application/x-amz-json-1.1"}
        ]
      }
    )
  end

  # The API wants keywords in lower camel case format
  # this function works thru a KeyWord which may have one
  # layer of KeyWord within it and builds a map where keys
  # are in this format.
  #
  # [test: [my_key: "val"]] becomes %{"test" => %{"myKey" => "val"}}
  defp camelize_keyword(a_list) when is_list(a_list) or is_map(a_list) do
    case Keyword.keyword?(a_list) or is_map(a_list) do
      true ->
        a_list
        |> Enum.reduce(%{}, fn {k, v}, acc ->
          k_str =
            case is_atom(k) do
              true ->
                k |> Atom.to_string() |> Macro.camelize() |> decap()

              false ->
                k
            end

          Map.put(acc, k_str, camelize_keyword(v))
        end)

      false ->
        a_list
        |> Enum.reduce([], fn item, acc -> [camelize_keyword(item) | acc] end)
        |> Enum.reverse()
    end
  end

  defp camelize_keyword(val), do: val

  defp decap(str) do
    first = String.slice(str, 0..0) |> String.downcase()
    first <> String.slice(str, 1..-1)
  end
end
