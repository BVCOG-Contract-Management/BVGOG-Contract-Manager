# Database Schema Creation and Documentation

## Database Schema
To create the database model using Rails, run the following command:
```
rails generate model <model_name> <attribute_name>:<attribute_type> <attribute_name>:<attribute_type> ...
```
For example, to create a model called `User` with attributes `name` and `email`, run the following command:
```
rails generate model User name:string email:string
```

This will create a file called `user.rb` in the `app/models` directory. This file contains the model definition, which is a Ruby class that inherits from `ActiveRecord::Base`. The model definition also contains the attributes of the model, which are defined as Ruby symbols. For example, the `User` model definition looks like this:
```
class User < ActiveRecord::Base
end
```
A migration file is also created in the `db/migrate` directory. This file contains the instructions for creating the database table for the model. For example, the `User` migration file looks like this:
```
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps null: false
    end
  end
end
```

To generate a model that references another model, use the `references type for a column` syntax. For example, to create a model called `Post` that references the `User` model, run the following command:
```
rails generate model Post title:string content:text user:references
```

## Associations
To create associations between models, use the `has_many`, `belongs_to`, and `has_and_belongs_to_many` methods. For example, to create a `has_many` association between the `User` and `Post` models, add the following line to the `User` model definition (in `app/models/user.rb`)):
```
has_many :posts
```
To create a `belongs_to` association between the `User` and `Post` models, add the following line to the `Post` model definition:
```
belongs_to :user
```
To create a `has_and_belongs_to_many` association between the `User` and `Post` models, add the following line to the `User` model definition:
```
has_and_belongs_to_many :posts
```
When you should use each type of association is explained in the [Rails Guides](http://guides.rubyonrails.org/association_basics.html). In short:
* `has_many` is used when a model has many instances of another model. For example, a `User` has many `Post`s.
* `belongs_to` is used when a model belongs to another model. For example, a `Post` belongs to a `User`.
* `has_and_belongs_to_many` is used when a model has and belongs to many instances of another model. For example, a `User` has and belongs to many `Post`s.

You can define associations in either model definition. For example, you can define the `has_many` association between `User` and `Post` in the `User` model definition or in the `Post` model definition, it really depends on which model you think makes more sense.
You can also set up associations bidirectioanlly. For example, if you define the `has_many` association between `User` and `Post` in the `User` model definition, you can also define the `belongs_to` association between `User` and `Post` in the `Post` model definition. This is useful if you want to access the other model from the current model. For example, if you have a `Post` instance called `post`, you can access the `User` instance that created the `Post` by calling `post.user`.
```
examples:
# get the user that created the post
post = Post.find(1)
user = post.user

# get all posts created by the user
user = User.find(1)
posts = user.posts
```

## CRUD Operations

Rails eliminates the need to write SQL queries to create, read, update, and delete data from the database. Instead, you can use the `create`, `find`, `update`, and `destroy` methods. For example, to create a new `User` instance, you can use the `create` method:
```
user = User.create(name: "John Doe", email: "john@email.com")
```
Note that `create` both builds and saves the instance. If you want to build the instance without saving it, you can use the `new` method:
```
user = User.new(name: "John Doe", email: "john@email.com")
```
And then save it using the `save` method:
```
user.save
```
To read data from the database, you can use the `find` method:
```
user = User.find(1)
```
Again, assuming our user has many posts, we can access the posts using the `posts` method:
```
posts = user.posts
```
To update an instance, you can use the `update` method:
```
user.update(name: "Jane Doe")
```
To delete an instance, you can use the `destroy` method:
```
user.destroy
```

## Enumerations
We are using the `enumerate_it` gem to create enumerations, since it is more flexible than the built-in Rails enumerations. To create an enumeration, use the following command:
```
rails generate enumerate_it:enum <enum_name> <attribute_name> <value1> <value2> ...
```
For example, to create an enumeration called `PostType` with attributes `name` and `value`, run the following command:
```
rails generate enumerate_it:enum PostType name value
```
This will create a file called `post_type.rb` in the `app/enumerations` directory. This file contains the enumeration definition, which is a Ruby class that inherits from `EnumerateIt::Base`. The enumeration definition also contains the attributes of the enumeration, which are defined as Ruby symbols. For example, the `PostType` enumeration definition looks like this:
```
class PostType < EnumerateIt::Base
  associate_values(
    :announcement
    :question
    :discussion
  )
end
```
These enumerations have text values by default. To have a column in your table be an enumeration, you need to add a column to your table that is of type `text` and then add the following line to your model definition:
```
has_enumeration_for :<column_name>, with: <enum_name>, create_helpers: true
```
For example, to add an enumeration to the `Post` model, add the following line to the `Post` model definition (in `app/models/post.rb`):
```
has_enumeration_for :post_type, with: PostType, create_helpers: true
```
The `create_helpers` option creates helper methods for the enumeration. For example, if you have an enumeration called `PostType` with values `:announcement`, `:question`, and `:discussion`, the helper methods will be `announcement?`, `question?`, and `discussion?`. See the [EnumerateIt documentation](https://github.com/lucascaton/enumerate_it) for more information.

To use these values, the actual names of each value is all caps and separated by underscores. For example, if you have an enumeration called `PostType` with values `:announcement`, `:question`, and `:discussion`, the values will be `ANNOUNCEMENT`, `QUESTION`, and `DISCUSSION`.

## RSpec Model Testing
With RSpec installed, generating a model will also generate a corresponding RSpec model test file. For example, if you generate a `User` model, a `user_spec.rb` file will be created in the `spec/models` directory. This file contains the RSpec tests for the `User` model. To run the tests, run the following command:
```
rspec
```

A test file for a model has the following structure:
```
require 'rails_helper'

RSpec.describe <model_name>, type: :model do
  # tests go here
end
```
A test that checks that a user cannot be created without a name would look like this:
```
it "is invalid without a name" do
  user = User.new(name: nil)
  user.valid?
  expect(user.errors[:name]).to include("can't be blank")
end
```

## Factories
We are using the `factory_bot_rails` gem to create factories. A factory is a Ruby class that contains the attributes of a model. It can generate a model instance with the specified attributes. For example, if you have a `User` model with attributes `name` and `email`, you can create a factory for the `User` model that generates a `User` instance with the specified attributes. To create a factory, add a file called `user_factory.rb` to the `spec/factories` directory.
A factory file has the following structure:
```
FactoryBot.define do
  factory :<model_name> do
    # attributes go here
  end
end
```
For example, if you have a `User` model with attributes `name` and `email`, the factory file would look like this:
```
FactoryBot.define do
  factory :user do
    name "John Doe"
    email "john@email.com"
    end
end
```

## Faker
We are using the `faker` gem to generate fake data. Faker allows you to generate fake data for your factories. This makes generating random data for your tests easier. 
Faker's documentation can be found [here](https://www.rubydoc.info/gems/faker/Faker).
It has a ton of different types of data that you can generate, including names, addresses, phone numbers, and more. For example, to generate a fake name, you can use the following code:
```
Faker::Name.name
```
In a factory, you can use Faker to generate random data for your attributes. For our user factory, we can use Faker to generate random names and emails:
```
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
```

Then in our RSpec test, we can use the factory to generate a random user:
```
RSpec.describe User, type: :model do
   include FactoryBot::Syntax::Methods

    it "is invalid without a name" do
      user = build(:user, name: nil)
      expect { user.save! }.to raise_error(ActiveRecord::NotNullViolation)
    end
end
```