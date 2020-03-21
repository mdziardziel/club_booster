require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: "2.0",
      info: {
        title: 'API V1',
        version: 'v1',
        description: "Instrukcja: \n" \
          "1. Utwórz konto przez `post /api/users` \n" \
          "2. Uwierzytelnij się używając danych podanych podczas rejestracji przez `post /api/authentication`.\n" \
          "\t Otrzymasz unikalny JSON Web Token (jwt) z którego pomocą będziesz mógł się autoryzować podczas wykonywania zapytań.\n" \
          "\t Aby to zrobić, skopiuj otrzymany token i podawaj w nagłówku `Authorization`. \n" \
          "\t Token jest ważny przez 100 lat, aby go przedawnić odpytaj kolejny raz punkt końcowy dostępny pod `post /api/authentication`.\n" \
          "\t Otrzymasz nowy token, a stary będzie nieaktualny.\n" \
          "3. Możesz stworzyć wiele klubów, aby tego dokonać wykonaj `post /api/clubs/`.\n" \
          "\t Zoastaniesz automatycznie gratyfikowany rolą `PRESIDENT`.\n" \
          "\t Po stworzeniu klubu otrzymasz token, dzięki któremu inni uczestnicy będą mogli dołączyć do klubu, " \
          "\t jednak będziesz musiał jeszcze zaakceptować ich kandydaturę przez `post /api/clubs/{club_id}/members/{member_id}/approve`.\n" \
          "4. Możesz dołączyć do wielu klubów, aby tego dokonać wykonaj `post /api/clubs/{club_id}/members`.\n"
          "5. Możesz wyświetlić wydarzenia/ogłoszenia, tylko dla danego klubu, lub dla wszystkich klubów.\n" \
          "\t Wydarzenia/ogłoszenia w ścieżce /clubs/{club_id} dotyczą tylko wybranego klubu.\n" \
          "\t Widzisz wydarzenia/ogłoszenia tylko skierowane do ciebie.\n"
      },
      paths: {}
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
