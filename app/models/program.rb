class Program < ApplicationRecord
    has_many :contracts, class_name: "Contract"
end
