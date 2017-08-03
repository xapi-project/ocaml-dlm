(*
 * Copyright (C) Citrix Systems Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.md.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *)

type t
(** the type of a DLM lockspace *)

(** [join ?mode lockspace] creates and joins the specified [lockspace]
    on the current node. Requires CAP_SYSADMIN privileges.
    raises a Unix.Unix_error on failure
*)
val join : ?mode:PosixTypes.mode_t -> string -> unit Lwt.t

(** [leave ?force lockspace] leaves the specified [lockspace] *)
val leave : ?force:bool -> string -> unit Lwt.t

(** [with_lockspace lockspace ~f] opens an existing [lockspace],
    calls [f t] with the lockspace handle [t], and closes the lockspace
    after [f] terminates.
*)
val with_lockspace :
  string -> f:(t -> 'a Lwt.t) -> 'a Lwt.t

(** lock mode *)
type mode =
  | LKM_NLMODE (** null lock *)
  | LKM_CRMODE (** concurrent read *)
  | LKM_CWMODE (** concurrent write *)
  | LKM_PRMODE (** protected read *)
  | LKM_PWMODE (** protected write *)
  | LKM_EXMODE (** exclusive *)

(** [with_lock lshandle ?mode ?timeout lockname ~f]
    acquires [lockname] in lock[mode] and calls ~f when the lock is acquired,
    and releases the lock after [f] terminates.
    [timeout] specifies how long to wait for the lock to be acquired.
*)
val with_lock :
  t ->
  ?mode:mode ->
  ?timeout:float -> string -> f:(unit -> 'a Lwt.t) -> 'a Lwt.t
