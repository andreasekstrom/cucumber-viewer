hljs.LANGUAGES.gherkin_en = function() {
  return {
    defaultMode: {
      contains: [
        {
          className: 'feature',
          begin: '^\\s*(Feature).*$',
          relevance: 0
        },
        {
          className: 'keyword',
          begin: '^\\s*(But |And |Then |When |Given |\\* |Scenarios|Examples|Scenario Template|Scenario Outline|Scenario|Background)',
          relevance: 0
        },
        {
          className: 'string',
          begin: '\\|',
          relevance: 0
        },
        hljs.HASH_COMMENT_MODE,
        {
          className: 'string',
          begin: '"""', end: '"""',
          relevance: 10
        },
        hljs.APOS_STRING_MODE,
        hljs.QUOTE_STRING_MODE,
        hljs.C_NUMBER_MODE,
        {
          className: 'wip', begin: '@wip'
        },
        {
          className: 'annotation', begin: '@[^@\r\n\t ]+'
        }
      ]
    }
  };
}();
