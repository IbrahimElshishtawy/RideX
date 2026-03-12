New-Item -Path "lib" -ItemType Directory

# Create the directories under 'lib'
$directories = @(
    "lib/main.dart",
    "lib/app/routes",
    "lib/app/theme",
    "lib/app/core/constants",
    "lib/app/core/helpers",
    "lib/app/core/services",
    "lib/app/core/widgets",
    "lib/app/core/base",
    "lib/data/models",
    "lib/data/providers",
    "lib/data/repositories",
    "lib/modules/splash/bindings",
    "lib/modules/splash/controllers",
    "lib/modules/splash/views",
    "lib/modules/onboarding/bindings",
    "lib/modules/onboarding/controllers",
    "lib/modules/onboarding/models",
    "lib/modules/onboarding/views",
    "lib/modules/auth/login/bindings",
    "lib/modules/auth/login/controllers",
    "lib/modules/auth/login/views",
    "lib/modules/main_nav/bindings",
    "lib/modules/main_nav/controllers",
    "lib/modules/main_nav/views",
    "lib/modules/home/bindings",
    "lib/modules/home/controllers",
    "lib/modules/home/views",
    "lib/modules/restaurant_details/bindings",
    "lib/modules/restaurant_details/controllers",
    "lib/modules/restaurant_details/views",
    "lib/modules/cart/bindings",
    "lib/modules/cart/controllers",
    "lib/modules/cart/views",
    "lib/modules/profile/bindings",
    "lib/modules/profile/controllers",
    "lib/modules/profile/views"
)

foreach ($dir in $directories) {
    New-Item -Path $dir -ItemType Directory -Force
}