begin;

    create table account(
        id int primary key,
        parent_id int references account(id)
    );

    insert into public.account(id, parent_id)
    values
        (1, 1);


    select jsonb_pretty(
        graphql.resolve($$
    query Abc {
      __typename
      accountCollection {
        __typename
        pageInfo {
          __typename
        }
        edges {
          __typename
          node {
            __typename
            parent {
              __typename
            }
          }
        }
      }
    }
        $$)
    );

    select jsonb_pretty(
        graphql.resolve($$
    mutation Abc {
      __typename
      insertIntoAccountCollection(objects: [
        { id: 2, parentId: 1 }
      ]) {
        __typename
        records {
          __typename
        }
      }
    }
        $$)
    );

    select jsonb_pretty(
        graphql.resolve($$
    mutation {
      updateAccountCollection(
        set: { parentId: 1 }
        atMost: 100
      ) {
        __typename
        records {
          id
          __typename
        }
      }
    }
        $$)
    );

    select jsonb_pretty(
        graphql.resolve($$
    mutation {
      deleteFromAccountCollection(atMost: 100) {
        __typename
        records {
          __typename
        }
      }
    }
        $$)
    );

    -- Reset data for byPk tests
    insert into public.account(id, parent_id)
    values
        (1, 1),
        (2, 1);

    -- Test __typename with byPk query
    select jsonb_pretty(
        graphql.resolve($$
    query {
      accountByPk(id: 1) {
        __typename
        id
        parent {
          __typename
          id
        }
      }
    }
        $$)
    );

    -- Test __typename with byPk query returning null
    select jsonb_pretty(
        graphql.resolve($$
    query {
      accountByPk(id: 999) {
        __typename
        id
      }
    }
        $$)
    );

rollback;
