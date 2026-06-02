// Copyright (C) 2026 Víctor Carreras
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/// Anotación para marcar un Widget que será exportado al LLM local.
class GenerativeUi {
  /// Nombre opcional para el componente. Si es null, el generador 
  /// usará el nombre de la clase de Dart.
  final String? name;

  const GenerativeUi({this.name});
}

const generativeUi = GenerativeUi();