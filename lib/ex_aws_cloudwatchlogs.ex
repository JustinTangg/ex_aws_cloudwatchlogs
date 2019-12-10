defmodule ExAws.CloudWatchLogs do
  @moduledoc """
  Documentation for ExAws.CloudWatchLogs.
  """

  # version of the AWS API
  @version "20140328"
  @namespace "Logs"

  @type tag :: %{key: binary, value: binary}
  @type log_event :: %{timestamp: integer, message: binary}
  @type metric_transformation :: %{
          metric_name: binary,
          metric_namespace: binary,
          metric_value: binary,
          default_value: float
        }

  @doc """
    Associates the specified AWS Key Management Service (AWS KMS) customer master key (CMK) with the specified log group.

    Associating an AWS KMS CMK with a log group overrides any existing associations between the log group and a CMK. After a CMK is associated with a log group, all newly ingested data for the log group is encrypted using the CMK. This association is stored as long as the data encrypted with the CMK is still within Amazon CloudWatch Logs. This enables Amazon CloudWatch Logs to decrypt this data whenever it is requested.

    Note that it can take up to 5 minutes for this operation to take effect.

    If you attempt to associate a CMK with a log group but the CMK does not exist or the CMK is disabled, you will receive an InvalidParameterException error.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/AssociateKmsKey

        ## Examples:
          iex> ExAws.CloudWatchLogs.associate_kms_key("test_log_group", "abcd1234")
          %ExAws.Operation.JSON{
            before_request: nil,
            data: %{"kmsKeyId" => "abcd1234", "logGroupName" => "test_log_group"},
            headers: [
              {"x-amz-target", "Logs_20140328.AssociateKmsKey"},
              {"content-type", "application/x-amz-json-1.1"}
            ],
            http_method: :post,
            params: %{},
            parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
            path: "/",
            service: :logs,
            stream_builder: nil
          }
  """
  @spec associate_kms_key(log_group_name :: binary, kms_key_id :: binary) ::
          ExAws.Operation.JSON.t()
  def associate_kms_key(log_group_name, kms_key_id) do
    %{
      "logGroupName" => log_group_name,
      "kmsKeyId" => kms_key_id
    }
    |> request(:associate_kms_key)
  end

  @doc """
    Cancels the specified export task.

    The task must be in the PENDING or RUNNING state.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/CancelExportTask

      ## Examples:
        iex> ExAws.CloudWatchLogs.cancel_export_task("export_task_id")
        %ExAws.Operation.JSON{
          before_request: nil,
          data: %{"taskId" => "export_task_id"},
          headers: [
            {"x-amz-target", "Logs_20140328.CancelExportTask"},
            {"content-type", "application/x-amz-json-1.1"}
          ],
          http_method: :post,
          params: %{},
          parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
          path: "/",
          service: :logs,
          stream_builder: nil
        }
  """
  @spec cancel_export_task(task_id :: binary) :: ExAws.Operation.JSON.t()
  def cancel_export_task(task_id) do
    %{
      "taskId" => task_id
    }
    |> request(:cancel_export_task)
  end

  @doc """
    Creates an export task, which allows you to efficiently export data from a log group to an Amazon S3 bucket.

    This is an asynchronous call. If all the required information is provided, this operation initiates an export task and responds with the ID of the task. After the task has started, you can use DescribeExportTasks to get the status of the export task. Each account can only have one active (RUNNING or PENDING ) export task at a time. To cancel an export task, use CancelExportTask .

    You can export logs from multiple log groups or multiple time ranges to the same S3 bucket. To separate out log data for each export task, you can specify a prefix to be used as the Amazon S3 key prefix for all exported objects.

    Exporting to S3 buckets that are encrypted with AES-256 is supported. Exporting to S3 buckets encrypted with SSE-KMS is not supported.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/CreateExportTask

      ## Examples:
        iex> ExAws.CloudWatchLogs.create_export_task("test_log_group", 1575984151, 1575984165, "dest", [task_name: "test_task"])
        %ExAws.Operation.JSON{
          before_request: nil,
          data: %{
            "destination" => "dest",
            "fromTime" => 1575984151,
            "logGroupName" => "test_log_group",
            "taskName" => "test_task",
            "to" => 1575984165
          },
          headers: [
            {"x-amz-target", "Logs_20140328.CreateExportTask"},
            {"content-type", "application/x-amz-json-1.1"}
          ],
          http_method: :post,
          params: %{},
          parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
          path: "/",
          service: :logs,
          stream_builder: nil
        }

  """
  @type create_export_task_opts :: %{
          task_name: binary,
          log_stream_name_prefix: binary,
          destination_prefix: binary
        }
  @spec create_export_task(
          log_group_name :: binary,
          from_time :: integer,
          to :: integer,
          destination :: binary
        ) :: ExAws.Operation.JSON.t()
  @spec create_export_task(
          log_group_name :: binary,
          from_time :: integer,
          to :: integer,
          destination :: binary,
          create_export_task_opts
        ) :: ExAws.Operation.JSON.t()
  def create_export_task(log_group_name, from_time, to, destination, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{
      "logGroupName" => log_group_name,
      "fromTime" => from_time,
      "to" => to,
      "destination" => destination
    })
    |> request(:create_export_task)
  end

  @doc """
    Creates a log group with the specified name.

    You can create up to 5000 log groups per account.

    You must use the following guidelines when naming a log group:

    Log group names must be unique within a region for an AWS account.
    Log group names can be between 1 and 512 characters long.
    Log group names consist of the following characters: a-z, A-Z, 0-9, '_' (underscore), '-' (hyphen), '/' (forward slash), and '.' (period).
    If you associate a AWS Key Management Service (AWS KMS) customer master key (CMK) with the log group, ingested data is encrypted using the CMK. This association is stored as long as the data encrypted with the CMK is still within Amazon CloudWatch Logs. This enables Amazon CloudWatch Logs to decrypt this data whenever it is requested.

    If you attempt to associate a CMK with the log group but the CMK does not exist or the CMK is disabled, you will receive an InvalidParameterException error.

    ## Examples:

        iex> ExAws.CloudWatchLogs.create_log_group("test_group")
        %ExAws.Operation.JSON{
          before_request: nil,
          data: %{"logGroupName" => "test_group"},
          headers: [
            {"x-amz-target", "Logs_20140328.CreateLogGroup"},
            {"content-type", "application/x-amz-json-1.1"}
          ],
          http_method: :post,
          params: %{},
          parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
          path: "/",
          service: :logs,
          stream_builder: nil
        }
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

  @doc """
    Creates a log stream for the specified log group.

    There is no limit on the number of log streams that you can create for a log group.

    You must use the following guidelines when naming a log stream:

        Log stream names must be unique within the log group.
        Log stream names can be between 1 and 512 characters long.
        The ':' (colon) and '*' (asterisk) characters are not allowed.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/CreateLogStream

      ## Examples:
      iex> ExAws.CloudWatchLogs.create_log_stream("test_log_group", "test_log_stream")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "logGroupName" => "test_log_group",
          "logStreamName" => "test_log_stream"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.CreateLogStream"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
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
    Deletes the specified destination, and eventually disables all the subscription filters that publish to it. This operation does not delete the physical resource encapsulated by the destination.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DeleteDestination

      ## Examples:
      iex> ExAws.CloudWatchLogs.delete_destination("dest")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"destinationName" => "dest"},
        headers: [
          {"x-amz-target", "Logs_20140328.DeleteDestination"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec delete_destination(destination_name :: binary) :: ExAws.Operation.JSON.t()
  def delete_destination(destination_name) do
    %{
      "destinationName" => destination_name
    }
    |> request(:delete_destination)
  end

  @doc """
    Deletes the specified log group and permanently deletes all the archived log events associated with the log group.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DeleteLogGroup

      ## Examples:
      iex> ExAws.CloudWatchLogs.delete_log_group("test_log_group")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.DeleteLogGroup"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec delete_log_group(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  def delete_log_group(log_group_name) do
    %{
      "logGroupName" => log_group_name
    }
    |> request(:delete_log_group)
  end

  @doc """
    Deletes the specified log stream and permanently deletes all the archived log events associated with the log stream.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DeleteLogStream

      ## Examples:
      iex> ExAws.CloudWatchLogs.delete_log_stream("test_log_group", "test_log_stream")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "logGroupName" => "test_log_group",
          "logStreamName" => "test_log_stream"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.DeleteLogStream"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec delete_log_stream(log_group_name :: binary, log_stream_name :: binary) ::
          ExAws.Operation.JSON.t()
  def delete_log_stream(log_group_name, log_stream_name) do
    %{
      "logGroupName" => log_group_name,
      "logStreamName" => log_stream_name
    }
    |> request(:delete_log_stream)
  end

  @doc """
    Deletes the specified metric filter.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DeleteMetricFilter

      ## Examples:
      iex> ExAws.CloudWatchLogs.delete_metric_filter("test_log_group", "test_metric_filter")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "filterName" => "test_metric_filter",
          "logGroupName" => "test_log_group"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.DeleteMetricFilter"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec delete_metric_filter(log_group_name :: binary, filter_name :: binary) ::
          ExAws.Operation.JSON.t()
  def delete_metric_filter(log_group_name, filter_name) do
    %{
      "logGroupName" => log_group_name,
      "filterName" => filter_name
    }
    |> request(:delete_metric_filter)
  end

  @doc """
    Deletes a resource policy from this account. This revokes the access of the identities in that policy to put log events to this account.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DeleteResourcePolicy

      ## Examples:
      iex> ExAws.CloudWatchLogs.delete_resource_policy("test_policy")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"policyName" => "test_policy"},
        headers: [
          {"x-amz-target", "Logs_20140328.DeleteResourcePolicy"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec delete_resource_policy(policy_name :: binary) :: ExAws.Operation.JSON.t()
  def delete_resource_policy(policy_name) do
    %{
      "policyName" => policy_name
    }
    |> request(:delete_resource_policy)
  end

  @doc """
    Deletes the specified retention policy.

    Log events do not expire if they belong to log groups without a retention policy.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DeleteRetentionPolicy

      ## Examples:
      iex> ExAws.CloudWatchLogs.delete_retention_policy("test_log_group")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.DeleteRetentionPolicy"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec delete_retention_policy(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  def delete_retention_policy(log_group_name) do
    %{
      "logGroupName" => log_group_name
    }
    |> request(:delete_retention_policy)
  end

  @doc """
    Deletes the specified subscription filter.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DeleteSubscriptionFilter

      ## Examples:
      iex> ExAws.CloudWatchLogs.delete_subscription_filter("test_log_group", "test_filter")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"filterName" => "test_filter", "logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.DeleteSubscriptionFilter"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec delete_subscription_filter(log_group_name :: binary, filter_name :: binary) ::
          ExAws.Operation.JSON.t()
  def delete_subscription_filter(log_group_name, filter_name) do
    %{
      "logGroupName" => log_group_name,
      "filterName" => filter_name
    }
    |> request(:delete_subscription_filter)
  end

  @doc """
    Lists all your destinations. The results are ASCII-sorted by destination name.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeDestinations

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_destinations([destination_name_prefix: "test_dest", limit: 10])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"destinationNamePrefix" => "test_dest", "limit" => 10},
        headers: [
          {"x-amz-target", "Logs_20140328.DescribeDestinations"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type describe_destinations_opts :: %{
          destination_name_prefix: binary,
          next_token: binary,
          limit: integer
        }
  @spec describe_destinations() :: ExAws.Operation.JSON.t()
  @spec describe_destinations(describe_destinations_opts) :: ExAws.Operation.JSON.t()
  def describe_destinations(opts \\ []) do
    opts
    |> camelize_keyword()
    |> request(:describe_destinations)
  end

  @doc """
    Lists the specified export tasks. You can list all your export tasks or filter the results based on task ID or task status.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeExportTasks

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_export_tasks([task_id: "test_task", limit: 50])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"limit" => 50, "taskId" => "test_task"},
        headers: [
          {"x-amz-target", "Logs_20140328.DescribeExportTasks"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type describe_export_tasks_opts :: %{
          task_id: binary,
          status_code: binary,
          next_token: binary,
          limit: integer
        }
  @spec describe_export_tasks() :: ExAws.Operation.JSON.t()
  @spec describe_export_tasks(describe_export_tasks_opts) :: ExAws.Operation.JSON.t()
  def describe_export_tasks(opts \\ []) do
    opts
    |> camelize_keyword()
    |> request(:describe_export_tasks)
  end

  @doc """
    Lists the specified log groups. You can list all your log groups or filter the results by prefix. The results are ASCII-sorted by log group name.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeLogGroups

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_log_groups()
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{},
        headers: [
          {"x-amz-target", "Logs_20140328.DescribeLogGroups"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
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

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeLogStreams

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_log_streams("test_log_group")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.DescribeLogStreams"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
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

  @doc """
    Lists the specified metric filters. You can list all the metric filters or filter the results by log name, prefix, metric name, or metric namespace. The results are ASCII-sorted by filter name.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeMetricFilters

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_metric_filters([log_group_name: "test_log_group", limit: 5])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"limit" => 5, "logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.DescribeMetricFilters"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type describe_metric_filters_opts :: %{
          log_group_name: binary,
          filter_name_prefix: binary,
          next_token: binary,
          limit: integer,
          metric_name: binary,
          metric_namespace: binary
        }
  @spec describe_metric_filters() :: ExAws.Operation.JSON.t()
  @spec describe_metric_filters(describe_metric_filters_opts) :: ExAws.Operation.JSON.t()
  def describe_metric_filters(opts \\ []) do
    opts
    |> camelize_keyword()
    |> request(:describe_metric_filters)
  end

  @doc """
    Returns a list of CloudWatch Logs Insights queries that are scheduled, executing, or have been executed recently in this account. You can request all queries, or limit it to queries of a specific log group or queries with a certain status.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeQueries

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_queries()
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{},
        headers: [
          {"x-amz-target", "Logs_20140328.DescribeQueries"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type describe_queries_opts :: %{
          log_group_name: binary,
          status: binary,
          max_results: integer,
          next_token: binary
        }
  @spec describe_queries() :: ExAws.Operation.JSON.t()
  @spec describe_queries(describe_queries_opts) :: ExAws.Operation.JSON.t()
  def describe_queries(opts \\ []) do
    opts
    |> camelize_keyword()
    |> request(:describe_queries)
  end

  @doc """
    Lists the resource policies in this account.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeResourcePolicies

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_resource_policies([next_token: "responseNextToken", limit: 1000])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"limit" => 1000, "nextToken" => "responseNextToken"},
        headers: [
          {"x-amz-target", "Logs_20140328.DescribeResourcePolicies"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type describe_resource_policies_opts :: %{
          next_token: binary,
          limit: integer
        }
  @spec describe_resource_policies() :: ExAws.Operation.JSON.t()
  @spec describe_resource_policies(describe_resource_policies_opts) :: ExAws.Operation.JSON.t()
  def describe_resource_policies(opts \\ []) do
    opts
    |> camelize_keyword()
    |> request(:describe_resource_policies)
  end

  @doc """
    Lists the subscription filters for the specified log group. You can list all the subscription filters or filter the results by prefix. The results are ASCII-sorted by filter name.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DescribeSubscriptionFilters

      ## Examples:
      iex> ExAws.CloudWatchLogs.describe_subscription_filters("test_log_group")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.DesribeSubscriptionFilters"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type describe_subscription_filters_opts :: %{
          filter_name_prefix: binary,
          next_token: binary,
          limit: integer
        }
  @spec describe_subscription_filters(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  @spec describe_subscription_filters(
          log_group_name :: binary,
          describe_subscription_filters_opts
        ) :: ExAws.Operation.JSON.t()
  def describe_subscription_filters(log_group_name, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{"logGroupName" => log_group_name})
    |> request(:desribe_subscription_filters)
  end

  @doc """
    Disassociates the associated AWS Key Management Service (AWS KMS) customer master key (CMK) from the specified log group.

    After the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested.

    Note that it can take up to 5 minutes for this operation to take effect.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/DisassociateKmsKey

      ## Examples:
      iex> ExAws.CloudWatchLogs.disassociate_kms_key("test_log_group")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.DisassociateKmsKey"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec disassociate_kms_key(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  def disassociate_kms_key(log_group_name) do
    %{
      "logGroupName" => log_group_name
    }
    |> request(:disassociate_kms_key)
  end

  @doc """
    Lists log events from the specified log group. You can list all the log events or filter the results using a filter pattern, a time range, and the name of the log stream.

    By default, this operation returns as many log events as can fit in 1 MB (up to 10,000 log events), or all the events found within the time range that you specify. If the results include a token, then there are more log events available, and you can get additional results by specifying the token in a subsequent call.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/FilterLogEvents

      ## Examples:
      iex> ExAws.CloudWatchLogs.filter_log_events("test_log_group", [log_stream_names: ["test_log_stream1", "test_log_stream2"]])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "logGroupName" => "test_log_group",
          "logStreamNames" => ["test_log_stream1", "test_log_stream2"]
        },
        headers: [
          {"x-amz-target", "Logs_20140328.FilterLogEvents"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type filter_log_events_opts :: %{
          log_stream_names: [binary, ...],
          log_stream_name_prefix: binary,
          start_time: integer,
          end_time: integer,
          filter_pattern: binary,
          next_token: binary,
          limit: integer,
          interleaved: boolean
        }
  @spec filter_log_events(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  @spec filter_log_events(log_group_name :: binary, filter_log_events_opts) ::
          ExAws.Operation.JSON.t()
  def filter_log_events(log_group_name, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{"logGroupName" => log_group_name})
    |> request(:filter_log_events)
  end

  @doc """
    Lists log events from the specified log stream. You can list all the log events or filter using a time range.

    By default, this operation returns as many log events as can fit in a response size of 1MB (up to 10,000 log events). You can get additional log events by specifying one of the tokens in a subsequent call.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/GetLogEvents

      ## Examples:
      iex> ExAws.CloudWatchLogs.get_log_events("test_log_group", "test_log_stream")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "logGroupName" => "test_log_group",
          "logStreamName" => "test_log_stream"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.GetLogEvents"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type get_log_events_opts :: %{
          start_time: integer,
          end_time: integer,
          next_token: binary,
          limit: integer,
          start_from_head: boolean
        }
  @spec get_log_events(log_group_name :: binary, log_stream_name :: binary) ::
          ExAws.Operation.JSON.t()
  @spec get_log_events(log_group_name :: binary, log_stream_name :: binary, get_log_events_opts) ::
          ExAws.Operation.JSON.t()
  def get_log_events(log_group_name, log_stream_name, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{"logGroupName" => log_group_name, "logStreamName" => log_stream_name})
    |> request(:get_log_events)
  end

  @doc """
    Returns a list of the fields that are included in log events in the specified log group, along with the percentage of log events that contain each field. The search is limited to a time period that you specify.

    In the results, fields that start with @ are fields generated by CloudWatch Logs. For example, @timestamp is the timestamp of each log event.

    The response results are sorted by the frequency percentage, starting with the highest percentage.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/GetLogGroupFields

      ## Examples:
      iex> ExAws.CloudWatchLogs.get_log_group_fields("test_log_group", [time: 1575985700])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group", "time" => 1575985700},
        headers: [
          {"x-amz-target", "Logs_20140328.GetLogGroupFields"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type get_log_group_fields_opts :: %{
          time: integer
        }
  @spec get_log_group_fields(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  @spec get_log_group_fields(log_group_name :: binary, get_log_group_fields_opts) ::
          ExAws.Operation.JSON.t()
  def get_log_group_fields(log_group_name, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{"logGroupName" => log_group_name})
    |> request(:get_log_group_fields)
  end

  @doc """
    Retrieves all the fields and values of a single log event. All fields are retrieved, even if the original query that produced the logRecordPointer retrieved only a subset of fields. Fields are returned as field name/field value pairs.

    Additionally, the entire unparsed log event is returned within @message .

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/GetLogRecord

      ## Examples:
      iex> ExAws.CloudWatchLogs.get_log_record("test_log_record_pointer")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logRecordPointer" => "test_log_record_pointer"},
        headers: [
          {"x-amz-target", "Logs_20140328.GetLogRecord"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec get_log_record(log_record_pointer :: binary) :: ExAws.Operation.JSON.t()
  def get_log_record(log_record_pointer) do
    %{
      "logRecordPointer" => log_record_pointer
    }
    |> request(:get_log_record)
  end

  @doc """
    Returns the results from the specified query.

    Only the fields requested in the query are returned, along with a @ptr field which is the identifier for the log record. You can use the value of @ptr in a operation to get the full log record.

        - GetQueryResults does not start a query execution. To run a query, use .

    If the value of the Status field in the output is Running , this operation returns only partial results. If you see a value of Scheduled or Running for the status, you can retry the operation later to see the final results.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/GetQueryResults

      ## Examples:
      iex> ExAws.CloudWatchLogs.get_query_results("test_query")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"queryId" => "test_query"},
        headers: [
          {"x-amz-target", "Logs_20140328.GetQueryResults"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec get_query_results(query_id :: binary) :: ExAws.Operation.JSON.t()
  def get_query_results(query_id) do
    %{
      "queryId" => query_id
    }
    |> request(:get_query_results)
  end

  @doc """
    Lists the tags for the specified log group.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/ListTagsLogGroup

      ## Examples:
      iex> ExAws.CloudWatchLogs.list_tags_log_group("test_log_group")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group"},
        headers: [
          {"x-amz-target", "Logs_20140328.ListTagsLogGroup"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec list_tags_log_group(log_group_name :: binary) :: ExAws.Operation.JSON.t()
  def list_tags_log_group(log_group_name) do
    %{
      "logGroupName" => log_group_name
    }
    |> request(:list_tags_log_group)
  end

  @doc """
    Creates or updates a destination. This operation is used only to create destinations for cross-account subscriptions.

    A destination encapsulates a physical resource (such as an Amazon Kinesis stream) and enables you to subscribe to a real-time stream of log events for a different account, ingested using PutLogEvents .

    Through an access policy, a destination controls what is written to it. By default, PutDestination does not set any access policy with the destination, which means a cross-account user cannot call PutSubscriptionFilter against this destination. To enable this, the destination owner must call PutDestinationPolicy after PutDestination .

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/PutDestination

      ## Examples:
      iex> ExAws.CloudWatchLogs.put_destination("test_dest", "test_target", "test_role")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "destinationName" => "test_dest",
          "roleArn" => "test_role",
          "targetArn" => "test_target"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.PutDestination"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec put_destination(destination_name :: binary, target_arn :: binary, role_arn :: binary) ::
          ExAws.Operation.JSON.t()
  def put_destination(destination_name, target_arn, role_arn) do
    %{
      "destinationName" => destination_name,
      "targetArn" => target_arn,
      "roleArn" => role_arn
    }
    |> request(:put_destination)
  end

  @doc """
    Creates or updates an access policy associated with an existing destination. An access policy is an IAM policy document that is used to authorize claims to register a subscription filter against a given destination.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/PutDestinationPolicy

      ## Examples:
      iex> ExAws.CloudWatchLogs.put_destination_policy("test_dest", "test_access_policy")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "accessPolicy" => "test_access_policy",
          "destinationName" => "test_dest"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.PutDestinationPolicy"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec put_destination_policy(destination_name :: binary, access_policy :: binary) ::
          ExAws.Operation.JSON.t()
  def put_destination_policy(destination_name, access_policy) do
    %{
      "destinationName" => destination_name,
      "accessPolicy" => access_policy
    }
    |> request(:put_destination_policy)
  end

  @doc """
    Uploads a batch of log events to the specified log stream.

    You must include the sequence token obtained from the response of the previous call. An upload in a newly created log stream does not require a sequence token. You can also get the sequence token using DescribeLogStreams . If you call PutLogEvents twice within a narrow time period using the same value for sequenceToken , both calls may be successful, or one may be rejected.

    The batch of events must satisfy the following constraints:

        The maximum batch size is 1,048,576 bytes, and this size is calculated as the sum of all event messages in UTF-8, plus 26 bytes for each log event.
        None of the log events in the batch can be more than 2 hours in the future.
        None of the log events in the batch can be older than 14 days or older than the retention period of the log group.
        The log events in the batch must be in chronological ordered by their timestamp. The timestamp is the time the event occurred, expressed as the number of milliseconds after Jan 1, 1970 00:00:00 UTC. (In AWS Tools for PowerShell and the AWS SDK for .NET, the timestamp is specified in .NET format: yyyy-mm-ddThh:mm:ss. For example, 2017-09-15T13:45:30.)
        The maximum number of log events in a batch is 10,000.
        A batch of log events in a single request cannot span more than 24 hours. Otherwise, the operation fails.

    If a call to PutLogEvents returns "UnrecognizedClientException" the most likely cause is an invalid AWS access key ID or secret key.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/PutLogEvents

      ## Examples:
      iex> ExAws.CloudWatchLogs.put_log_events("test_log_group", "test_log_stream", [%{timestamp: 1575985975, message: "test_message"}, %{timestamp: 1575986000, message: "test_message1"}])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "logEvents" => [
            %{message: "test_message", timestamp: 1575985975},
            %{message: "test_message1", timestamp: 1575986000}
          ],
          "logGroupName" => "test_log_group",
          "logStreamName" => "test_log_stream"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.PutLogEvents"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type put_log_events_opts :: %{
          sequence_token: binary
        }
  @spec put_log_events(
          log_group_name :: binary,
          log_stream_name :: binary,
          log_events :: [log_event, ...]
        ) :: ExAws.Operation.JSON.t()
  @spec put_log_events(
          log_group_name :: binary,
          log_stream_name :: binary,
          log_events :: [log_event, ...],
          put_log_events_opts
        ) :: ExAws.Operation.JSON.t()
  def put_log_events(log_group_name, log_stream_name, log_events, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{
      "logGroupName" => log_group_name,
      "logStreamName" => log_stream_name,
      "logEvents" => log_events
    })
    |> request(:put_log_events)
  end

  @doc """
    Creates or updates a metric filter and associates it with the specified log group. Metric filters allow you to configure rules to extract metric data from log events ingested through PutLogEvents .

    The maximum number of metric filters that can be associated with a log group is 100.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/PutMetricFilter

      ## Examples:
      iex> ExAws.CloudWatchLogs.put_metric_filter("test_log_group", "test_filter", "test_filter_pattern", [%{metric_name: "test_metric", metric_namespace: "test_namespace", metric_value: "test_metric_value"}])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "filterName" => "test_filter",
          "filterPattern" => "test_filter_pattern",
          "logGroupName" => "test_log_group",
          "metricTransformations" => [
            %{
              metric_name: "test_metric",
              metric_namespace: "test_namespace",
              metric_value: "test_metric_value"
            }
          ]
        },
        headers: [
          {"x-amz-target", "Logs_20140328.PutMetricFilter"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec put_metric_filter(
          log_group_name :: binary,
          filter_name :: binary,
          filter_pattern :: binary,
          metric_transformations :: [metric_transformation, ...]
        ) :: ExAws.Operation.JSON.t()
  def put_metric_filter(log_group_name, filter_name, filter_pattern, metric_transformations) do
    %{
      "logGroupName" => log_group_name,
      "filterName" => filter_name,
      "filterPattern" => filter_pattern,
      "metricTransformations" => metric_transformations
    }
    |> request(:put_metric_filter)
  end

  @doc """
    Creates or updates a resource policy allowing other AWS services to put log events to this account, such as Amazon Route 53. An account can have up to 10 resource policies per region.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/PutResourcePolicy

      ## Examples:
      iex> ExAws.CloudWatchLogs.put_resource_policy("test_policy", "test_policy_doc")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"policyDocument" => "test_policy_doc", "policyName" => "test_policy"},
        headers: [
          {"x-amz-target", "Logs_20140328.PutResourcePolicy"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec put_resource_policy(policy_name :: binary, policy_document :: binary) ::
          ExAws.Operation.JSON.t()
  def put_resource_policy(policy_name, policy_document) do
    %{
      "policyName" => policy_name,
      "policyDocument" => policy_document
    }
    |> request(:put_resource_policy)
  end

  @doc """
    Sets the retention of the specified log group. A retention policy allows you to configure the number of days for which to retain log events in the specified log group.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/PutRetentionPolicy

      ## Examples:
      iex> ExAws.CloudWatchLogs.put_retention_policy("test_log_group", 1)
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"logGroupName" => "test_log_group", "retentionInDays" => 1},
        headers: [
          {"x-amz-target", "Logs_20140328.PutRetentionPolicy"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec put_retention_policy(log_group_name :: binary, retention_in_days :: integer) ::
          ExAws.Operation.JSON.t()
  def put_retention_policy(log_group_name, retention_in_days) do
    %{
      "logGroupName" => log_group_name,
      "retentionInDays" => retention_in_days
    }
    |> request(:put_retention_policy)
  end

  @doc """
   Creates or updates a subscription filter and associates it with the specified log group. Subscription filters allow you to subscribe to a real-time stream of log events ingested through PutLogEvents and have them delivered to a specific destination. Currently, the supported destinations are:

       - An Amazon Kinesis stream belonging to the same account as the subscription filter, for same-account delivery.
       - A logical destination that belongs to a different account, for cross-account delivery.
       - An Amazon Kinesis Firehose delivery stream that belongs to the same account as the subscription filter, for same-account delivery.
       - An AWS Lambda function that belongs to the same account as the subscription filter, for same-account delivery.

     There can only be one subscription filter associated with a log group. If you are updating an existing filter, you must specify the correct name in filterName . Otherwise, the call fails because you cannot associate a second filter with a log group.

     See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/PutSubscriptionFilter

      ## Examples:
      iex> ExAws.CloudWatchLogs.put_subscription_filter("test_log_group", "test_filter", "test_filter_pattern", "test_dest", [role_arn: "test_role"])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "destinationArn" => "test_dest",
          "filterName" => "test_filter",
          "filterPattern" => "test_filter_pattern",
          "logGroupName" => "test_log_group",
          "roleArn" => "test_role"
        },
        headers: [
          {"x-amz-target", "Logs_20140328.PutSubscriptionFilter"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type put_subscription_filter_opts :: %{
          role_arn: binary,
          distribution: binary
        }
  @spec put_subscription_filter(
          log_group_name :: binary,
          filter_name :: binary,
          filter_pattern :: binary,
          destination_arn :: binary
        ) :: ExAws.Operation.JSON.t()
  @spec put_subscription_filter(
          log_group_name :: binary,
          filter_name :: binary,
          filter_pattern :: binary,
          destination_arn :: binary,
          put_subscription_filter_opts
        ) :: ExAws.Operation.JSON.t()
  def put_subscription_filter(
        log_group_name,
        filter_name,
        filter_pattern,
        destination_arn,
        opts \\ []
      ) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{
      "logGroupName" => log_group_name,
      "filterName" => filter_name,
      "filterPattern" => filter_pattern,
      "destinationArn" => destination_arn
    })
    |> request(:put_subscription_filter)
  end

  @doc """
    Schedules a query of a log group using CloudWatch Logs Insights. You specify the log group and time range to query, and the query string to use.

    A StartQuery operation must include a logGroupNames or a logGroupName parameter, but not both.

    For more information, see [CloudWatch Logs Insights Query Syntax]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html .

    Queries time out after 15 minutes of execution. If your queries are timing out, reduce the time range being searched, or partition your query into a number of queries.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/StartQuery

      ## Examples:
      iex> ExAws.CloudWatchLogs.start_query("test_log_group", 1575986309, 1575986313, "test_query", [limit: 10])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "endTime" => 1575986313,
          "limit" => 10,
          "logGroupName" => "test_log_group",
          "queryString" => "test_query",
          "startTime" => 1575986309
        },
        headers: [
          {"x-amz-target", "Logs_20140328.StartQuery"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }

      iex> ExAws.CloudWatchLogs.start_query(["test_log_group", "test_log_group1"], 1575986309, 1575986313, "test_query", [limit: 10])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "endTime" => 1575986313,
          "limit" => 10,
          "logGroupNames" => ["test_log_group", "test_log_group1"],
          "queryString" => "test_query",
          "startTime" => 1575986309
        },
        headers: [
          {"x-amz-target", "Logs_20140328.StartQuery"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @type start_query_opts :: %{
          limit: integer
        }
  @spec start_query(
          log_group_name :: binary,
          start_time :: integer,
          end_time :: integer,
          query_string :: binary
        ) :: ExAws.Operation.JSON.t()
  @spec start_query(
          log_group_name :: binary,
          start_time :: integer,
          end_time :: integer,
          query_string :: binary,
          start_query_opts
        ) :: ExAws.Operation.JSON.t()
  @spec start_query(
          log_group_name :: [binary, ...],
          start_time :: integer,
          end_time :: integer,
          query_string :: binary
        ) :: ExAws.Operation.JSON.t()
  @spec start_query(
          log_group_name :: [binary, ...],
          start_time :: integer,
          end_time :: integer,
          query_string :: binary,
          start_query_opts
        ) :: ExAws.Operation.JSON.t()
  def start_query(log_group_name, start_time, end_time, query_string, opts \\ []) do
    opts
    |> camelize_keyword()
    |> Map.merge(%{
      get_log_group_name_key(log_group_name) => log_group_name,
      "startTime" => start_time,
      "endTime" => end_time,
      "queryString" => query_string
    })
    |> request(:start_query)
  end

  @doc """
    Stops a CloudWatch Logs Insights query that is in progress. If the query has already ended, the operation returns an error indicating that the specified query is not running.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/StopQuery

      ## Examples:
      iex> ExAws.CloudWatchLogs.stop_query("test_query_id")
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{"queryId" => "test_query_id"},
        headers: [
          {"x-amz-target", "Logs_20140328.StopQuery"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec stop_query(query_id :: binary) :: ExAws.Operation.JSON.t()
  def stop_query(query_id) do
    %{
      "queryId" => query_id
    }
    |> request(:stop_query)
  end

  @doc """
    Adds or updates the specified tags for the specified log group.

    To list the tags for a log group, use ListTagsLogGroup . To remove tags, use UntagLogGroup .

    For more information about tags, see [Tag Log Groups in Amazon CloudWatch Logs]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/log-group-tagging.html in the Amazon CloudWatch Logs User Guide .

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/TagLogGroup

      ## Examples:
      iex> ExAws.CloudWatchLogs.tag_log_group("test_log_group", [%{tagKey1: "tagValue"}, %{tagKey2: "tagValue2"}])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "logGroupName" => "test_log_group",
          "tags" => [%{tagKey1: "tagValue"}, %{tagKey2: "tagValue2"}]
        },
        headers: [
          {"x-amz-target", "Logs_20140328.TagLogGroup"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec tag_log_group(log_group_name :: binary, tags :: [tag, ...]) :: ExAws.Operation.JSON.t()
  def tag_log_group(log_group_name, tags) do
    %{
      "logGroupName" => log_group_name,
      "tags" => tags
    }
    |> request(:tag_log_group)
  end

  @doc """
    Tests the filter pattern of a metric filter against a sample of log event messages. You can use this operation to validate the correctness of a metric filter pattern.

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/TestMetricFilter

      ## Examples:
      iex> ExAws.CloudWatchLogs.test_metric_filter("test_filter_pattern", ["event1", "event2"])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "filterPattern" => "test_filter_pattern",
          "logEventMessages" => ["event1", "event2"]
        },
        headers: [
          {"x-amz-target", "Logs_20140328.TestMetricFilter"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec test_metric_filter(filter_pattern :: binary, log_event_messages :: [binary, ...]) ::
          ExAws.Operation.JSON.t()
  def test_metric_filter(filter_pattern, log_event_messages) do
    %{
      "filterPattern" => filter_pattern,
      "logEventMessages" => log_event_messages
    }
    |> request(:test_metric_filter)
  end

  @doc """
    Removes the specified tags from the specified log group.

    To list the tags for a log group, use ListTagsLogGroup . To add tags, use UntagLogGroup .

    See also: [AWS API Documentation]: https://docs.aws.amazon.com/goto/WebAPI/logs-2014-03-28/UntagLogGroup

      ## Examples:
      iex> ExAws.CloudWatchLogs.untag_log_group("test_log_group", ["testKey1", "testKey2", "testKey3"])
      %ExAws.Operation.JSON{
        before_request: nil,
        data: %{
          "logGroupName" => "test_log_group",
          "tags" => ["testKey1", "testKey2", "testKey3"]
        },
        headers: [
          {"x-amz-target", "Logs_20140328.UntagLogGroup"},
          {"content-type", "application/x-amz-json-1.1"}
        ],
        http_method: :post,
        params: %{},
        parser: #Function<1.12038698/1 in ExAws.Operation.JSON.new/2>,
        path: "/",
        service: :logs,
        stream_builder: nil
      }
  """
  @spec untag_log_group(log_group_name :: binary, tags :: [binary, ...]) ::
          ExAws.Operation.JSON.t()
  def untag_log_group(log_group_name, tags) do
    %{
      "logGroupName" => log_group_name,
      "tags" => tags
    }
    |> request(:untag_log_group)
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

  defp get_log_group_name_key(log_group_name) when is_binary(log_group_name), do: "logGroupName"
  defp get_log_group_name_key(log_group_name) when is_list(log_group_name), do: "logGroupNames"
end
