/// Defines the output schema format for the generated UI components.
enum SchemaFormat {
  /// A flat structure format. Maps fields directly to the root properties.
  flat,

  /// Google's Agent to UI (A2UI) nested schema format.
  /// Wraps fields inside a 'props' object and defines the type as 'component'.
  a2ui,
}
