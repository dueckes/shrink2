require Rails.root.join('lib/shrink/database')
require Rails.root.join('spec/support/database_model_fixture')

After { Shrink::Database.clear }

World(Shrink::DatabaseModelFixture)

