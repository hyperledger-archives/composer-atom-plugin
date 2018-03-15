###
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
###

describe "Regular Expression Replacement grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-javascript")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.js.regexp.replacement")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.js.regexp.replacement"

  describe "basic strings", ->
    it "tokenizes with no extra scopes", ->
      {tokens} = grammar.tokenizeLine('Hello [world]. (hi to you)')
      expect(tokens[0]).toEqual value: 'Hello [world]. (hi to you)', scopes: ['source.js.regexp.replacement']

  describe "escaped characters", ->
    it "tokenizes with as an escape character", ->
      {tokens} = grammar.tokenizeLine('\\n')
      expect(tokens[0]).toEqual value: '\\n', scopes: ['source.js.regexp.replacement', 'constant.character.escape.backslash.regexp.replacement']

    it "tokenizes '$$' as an escaped '$' character", ->
      {tokens} = grammar.tokenizeLine('$$')
      expect(tokens[0]).toEqual value: '$$', scopes: ['source.js.regexp.replacement', 'constant.character.escape.dollar.regexp.replacement']

    it "doesn't treat '\\$' as an escaped '$' character", ->
      {tokens} = grammar.tokenizeLine('\\$')
      expect(tokens[0]).toEqual value: '\\$', scopes: ['source.js.regexp.replacement']

    it "tokenizes '$$1' as an escaped '$' character followed by a '1' character", ->
      {tokens} = grammar.tokenizeLine('$$1')
      expect(tokens[0]).toEqual value: '$$', scopes: ['source.js.regexp.replacement', 'constant.character.escape.dollar.regexp.replacement']
      expect(tokens[1]).toEqual value: '1', scopes: ['source.js.regexp.replacement']

  describe "Numeric placeholders", ->
    it "doesn't tokenize $0 as a variable", ->
      {tokens} = grammar.tokenizeLine('$0')
      expect(tokens[0]).toEqual value: '$0', scopes: ['source.js.regexp.replacement']

    it "doesn't tokenize $00 as a variable", ->
      {tokens} = grammar.tokenizeLine('$00')
      expect(tokens[0]).toEqual value: '$00', scopes: ['source.js.regexp.replacement']

    it "tokenizes $1 as a variable", ->
      {tokens} = grammar.tokenizeLine('$1')
      expect(tokens[0]).toEqual value: '$1', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']

    it "tokenizes $01 as a variable", ->
      {tokens} = grammar.tokenizeLine('$01')
      expect(tokens[0]).toEqual value: '$01', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']

    it "tokenizes $3 as a variable", ->
      {tokens} = grammar.tokenizeLine('$3')
      expect(tokens[0]).toEqual value: '$3', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']

    it "tokenizes $10 as a variable", ->
      {tokens} = grammar.tokenizeLine('$10')
      expect(tokens[0]).toEqual value: '$10', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']

    it "tokenizes $99 as a variable", ->
      {tokens} = grammar.tokenizeLine('$99')
      expect(tokens[0]).toEqual value: '$99', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']

    it "doesn't tokenize the third numberic character in '$100' as a variable", ->
      {tokens} = grammar.tokenizeLine('$100')
      expect(tokens[0]).toEqual value: '$10', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']
      expect(tokens[1]).toEqual value: '0', scopes: ['source.js.regexp.replacement']

    describe "Matched sub-string placeholder", ->
      it "tokenizes $& as a variable", ->
        {tokens} = grammar.tokenizeLine('$&')
        expect(tokens[0]).toEqual value: '$&', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']

    describe "Preceeding portion placeholder", ->
      it "tokenizes $` as a variable", ->
        {tokens} = grammar.tokenizeLine('$`')
        expect(tokens[0]).toEqual value: '$`', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']

    describe "Following portion placeholder", ->
      it "tokenizes $' as a variable", ->
        {tokens} = grammar.tokenizeLine('$\'')
        expect(tokens[0]).toEqual value: '$\'', scopes: ['source.js.regexp.replacement', 'variable.regexp.replacement']
