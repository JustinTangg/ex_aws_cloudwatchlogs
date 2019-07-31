defmodule ExAws.CloudWatchLogs do
  @moduledoc """
  Documentation for ExAws.CloudWatchLogs.
  """

  use ExAws.Utils,
    format_type: :xml,
    non_standard_keys: %{}

  # version of the AWS API
  @version "2014-03-28"

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
  @spec create_log_group(log_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec create_log_group(log_group_name :: binary, create_log_group_opts) ::
          ExAws.Operation.Query.t()
  def create_log_group(log_group_name, opts \\ []) do
    [{:log_group_name, log_group_name} | opts]
    |> build_request(:create_log_group)
  end

  @spec create_log_stream(log_group_name :: binary, log_stream_name :: binary) ::
          ExAws.Operation.Query.t()
  def create_log_stream(log_group_name, log_stream_name) do
    [{:log_group_name, log_group_name}, {:log_stream_name, log_stream_name}]
    |> build_request(:create_log_stream)
  end

  ####################
  # Helper Functions #
  ####################

  defp build_request(opts, action) do
    opts
    |> Enum.flat_map(&format_param/1)
    |> request(action)
  end

  defp format_param({key, parameters}) do
    format([{key, parameters}])
  end

  defp request(params, action) do
    action_string = action |> Atom.to_string() |> Macro.camelize()

    %ExAws.Operation.Query{
      path: "/",
      params:
        params
        |> filter_nil_params
        |> Map.put("Action", action_string)
        |> Map.put("Version", @version),
      service: :logs,
      action: action
    }
  end
end
