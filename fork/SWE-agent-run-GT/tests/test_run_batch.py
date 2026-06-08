import json
import logging
from pathlib import Path
from types import SimpleNamespace

import pytest

from sweagent.run.run import main
from sweagent.run.run_batch import RunBatch


@pytest.mark.slow
def test_expert_instances(test_data_sources_path: Path, tmp_path: Path):
    ds_path = test_data_sources_path / "expert_instances.yaml"
    assert ds_path.exists()
    cmd = [
        "run-batch",
        "--agent.model.name",
        "instant_empty_submit",
        "--instances.type",
        "expert_file",
        "--instances.path",
        str(ds_path),
        "--output_dir",
        str(tmp_path),
        "--raise_exceptions",
        "True",
    ]
    main(cmd)
    for _id in ["simple_test_problem", "simple_test_problem_2"]:
        assert (tmp_path / f"{_id}" / f"{_id}.traj").exists(), list(tmp_path.iterdir())


@pytest.mark.slow
def test_simple_instances(test_data_sources_path: Path, tmp_path: Path):
    ds_path = test_data_sources_path / "simple_instances.yaml"
    assert ds_path.exists()
    cmd = [
        "run-batch",
        "--agent.model.name",
        "instant_empty_submit",
        "--instances.path",
        str(ds_path),
        "--output_dir",
        str(tmp_path),
        "--raise_exceptions",
        "True",
    ]
    main(cmd)
    assert (tmp_path / "simple_test_problem" / "simple_test_problem.traj").exists(), list(tmp_path.iterdir())


def test_empty_instances_simple(test_data_sources_path: Path, tmp_path: Path):
    ds_path = test_data_sources_path / "simple_instances.yaml"
    assert ds_path.exists()
    cmd = [
        "run-batch",
        "--agent.model.name",
        "instant_empty_submit",
        "--instances.path",
        str(ds_path),
        "--output_dir",
        str(tmp_path),
        "--raise_exceptions",
        "True",
        "--instances.filter",
        "doesnotmatch",
    ]
    with pytest.raises(ValueError, match="No instances to run"):
        main(cmd)


def test_empty_instances_expert(test_data_sources_path: Path, tmp_path: Path):
    ds_path = test_data_sources_path / "expert_instances.yaml"
    assert ds_path.exists()
    cmd = [
        "run-batch",
        "--agent.model.name",
        "instant_empty_submit",
        "--instances.path",
        str(ds_path),
        "--instances.type",
        "expert_file",
        "--output_dir",
        str(tmp_path),
        "--raise_exceptions",
        "True",
        "--instances.filter",
        "doesnotmatch",
    ]
    with pytest.raises(ValueError, match="No instances to run"):
        main(cmd)


@pytest.mark.parametrize(
    ("exit_status", "skip_reason"),
    [
        ("submitted", "submitted"),
        ("skipped (submitted)", "submitted"),
        ("submitted (exit_cost)", "submitted (exit_cost)"),
        ("skipped (submitted (exit_cost))", "submitted (exit_cost)"),
    ],
)
def test_should_skip_done_trajectory_statuses(tmp_path: Path, exit_status: str, skip_reason: str):
    instance_id = "example_instance"
    instance = SimpleNamespace(problem_statement=SimpleNamespace(id=instance_id))
    output_dir = tmp_path / instance_id
    output_dir.mkdir(parents=True)
    (output_dir / f"{instance_id}.traj").write_text(json.dumps({"info": {"exit_status": exit_status}}))
    (output_dir / "keep.txt").write_text("keep")
    run = SimpleNamespace(_redo_existing=False, output_dir=tmp_path, logger=logging.getLogger("test"))

    assert RunBatch.should_skip(run, instance) == skip_reason
    assert (output_dir / "keep.txt").exists()


@pytest.mark.parametrize("exit_status", ["early_exit", "exit_cost", None])
def test_should_skip_cleans_non_done_trajectory_statuses(tmp_path: Path, exit_status: str | None):
    instance_id = "example_instance"
    instance = SimpleNamespace(problem_statement=SimpleNamespace(id=instance_id))
    output_dir = tmp_path / instance_id
    output_dir.mkdir(parents=True)
    (output_dir / f"{instance_id}.traj").write_text(json.dumps({"info": {"exit_status": exit_status}}))
    (output_dir / f"{instance_id}.patch").write_text("stale patch")
    run = SimpleNamespace(_redo_existing=False, output_dir=tmp_path, logger=logging.getLogger("test"))

    assert RunBatch.should_skip(run, instance) is False
    assert not output_dir.exists()


def test_should_skip_cleans_existing_output_dir_without_trajectory(tmp_path: Path):
    instance_id = "example_instance"
    instance = SimpleNamespace(problem_statement=SimpleNamespace(id=instance_id))
    output_dir = tmp_path / instance_id
    output_dir.mkdir(parents=True)
    (output_dir / f"{instance_id}.patch").write_text("stale patch")
    run = SimpleNamespace(_redo_existing=False, output_dir=tmp_path, logger=logging.getLogger("test"))

    assert RunBatch.should_skip(run, instance) is False
    assert not output_dir.exists()


def test_should_skip_redo_existing_cleans_done_trajectory(tmp_path: Path):
    instance_id = "example_instance"
    instance = SimpleNamespace(problem_statement=SimpleNamespace(id=instance_id))
    output_dir = tmp_path / instance_id
    output_dir.mkdir(parents=True)
    (output_dir / f"{instance_id}.traj").write_text(json.dumps({"info": {"exit_status": "submitted"}}))
    run = SimpleNamespace(_redo_existing=True, output_dir=tmp_path, logger=logging.getLogger("test"))

    assert RunBatch.should_skip(run, instance) is False
    assert not output_dir.exists()


# This doesn't work because we need to retrieve environment variables from the environment
# in order to format our templates.
# def test_run_batch_swe_bench_instances(tmp_path: Path):
#     cmd = [
#         "run-batch",
#         "--agent.model.name",
#         "instant_empty_submit",
#         "--instances.subset",
#         "lite",
#         "--instances.split",
#         "test",
#         "--instances.slice",
#         "0:1",
#         "--output_dir",
#         str(tmp_path),
#         "--raise_exceptions",
#         "--instances.deployment.type",
#         "dummy",
#     ]
#     main(cmd)
