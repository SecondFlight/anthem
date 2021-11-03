/*
    Copyright (C) 2021 Joshua Wade

    This file is part of Anthem.

    Anthem is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Anthem is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Anthem. If not, see <https://www.gnu.org/licenses/>.
*/

use crate::commands::pattern_commands::*;
use crate::model::note::*;
use crate::model::pattern::*;
use crate::model::store::*;
use crate::util::execute_and_push::*;

fn get_note<'a>(
    store: &'a Store,
    project_id: &u64,
    pattern_id: &u64,
    instrument_id: &u64,
    note_id: &u64,
) -> &'a Note {
    &(store
        .projects
        .get(project_id)
        .unwrap()
        .song
        .patterns
        .get(pattern_id)
        .unwrap()
        .generator_notes
        .get(instrument_id)
        .unwrap()
        .notes
        .iter()
        .find(|note| note.id == *note_id)
        .unwrap())
}

pub fn pattern_message_handler(store: &mut Store, request_id: u64, msg: &Msg) -> bool {
    match msg {
        Msg::AddPattern(project_id, pattern_name) => {
            let command = AddPatternCommand {
                project_id: *project_id,
                pattern: Pattern::new(pattern_name.clone()),
                index: store
                    .projects
                    .get(project_id)
                    .unwrap()
                    .song
                    .pattern_order
                    .len(),
            };
            execute_and_push(store, request_id, *project_id, Box::new(command));
        }
        Msg::DeletePattern(project_id, pattern_id) => {
            let project = store.projects.get_mut(project_id).unwrap();
            let patterns = &mut project.song.patterns;

            let command = DeletePatternCommand {
                project_id: *project_id,
                pattern: patterns.get(pattern_id).unwrap().clone(),
                index: store
                    .projects
                    .get(project_id)
                    .unwrap()
                    .song
                    .pattern_order
                    .iter()
                    .position(|id| *id == *pattern_id)
                    .unwrap(),
            };

            execute_and_push(store, request_id, *project_id, Box::new(command));
        }
        Msg::AddNote(project_id, pattern_id, instrument_id, note_json) => {
            let note: Note = serde_json::from_str(note_json).unwrap();

            let command = AddNoteCommand {
                project_id: *project_id,
                pattern_id: *pattern_id,
                generator_id: *instrument_id,
                note,
            };

            execute_and_push(store, request_id, *project_id, Box::new(command));
        }
        Msg::DeleteNote(project_id, pattern_id, instrument_id, note_id) => {
            let note = get_note(store, project_id, pattern_id, instrument_id, note_id);

            let command = DeleteNoteCommand {
                project_id: *project_id,
                pattern_id: *pattern_id,
                generator_id: *instrument_id,
                note: note.clone(),
            };

            execute_and_push(store, request_id, *project_id, Box::new(command));
        }
        Msg::MoveNote(project_id, pattern_id, instrument_id, note_id, new_key, new_offset) => {
            let note = get_note(store, project_id, pattern_id, instrument_id, note_id);

            let command = MoveNoteCommand {
                project_id: *project_id,
                pattern_id: *pattern_id,
                generator_id: *instrument_id,
                note_id: *note_id,
                old_key: note.key,
                new_key: *new_key as u8,
                old_offset: note.offset,
                new_offset: *new_offset,
            };

            execute_and_push(store, request_id, *project_id, Box::new(command));
        }
        Msg::ResizeNote(project_id, pattern_id, instrument_id, note_id, new_length) => {
            let note = get_note(store, project_id, pattern_id, instrument_id, note_id);

            let command = ResizeNoteCommand {
                project_id: *project_id,
                pattern_id: *pattern_id,
                generator_id: *instrument_id,
                note_id: *note_id,
                old_length: note.length,
                new_length: *new_length,
            };

            execute_and_push(store, request_id, *project_id, Box::new(command));
        }
        _ => {
            return false;
        }
    }
    true
}
