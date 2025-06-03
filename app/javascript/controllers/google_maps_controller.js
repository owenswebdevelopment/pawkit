import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchButton", "mark"]

  connect() {
    // Initialize map centered at Meguro by default
    this.map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 35.633998, lng: 139.715653 }, // Meguro
      zoom: 13,
      mapId: "YOUR_MAP_ID" // Optional if you have a custom Map ID
    });

    window.googleMapsStimulusMapInstance = this.map; // For click-to-center

    this.markers = []; // Track markers
  }

  search() {
    console.log("Search clicked 🚀");

    navigator.geolocation.getCurrentPosition(async (position) => {
      const userLat = position.coords.latitude;
      const userLng = position.coords.longitude;

      console.log(`User location: ${userLat}, ${userLng}`);

      const selectedCategories = Array.from(
        document.querySelectorAll('input[name="category"]:checked')
      ).map(cb => cb.value);

      if (selectedCategories.length === 0) {
        alert("Please select at least one category.");
        return;
      }

      // Clear old markers
      this.clearMarkers();

      // Clear old cards immediately
      this.markTarget.innerHTML = "";

      // For each selected category, perform Nearby Search
      for (const category of selectedCategories) {
        await this.nearbySearch(userLat, userLng, category);
      }
    });
  }

  async nearbySearch(lat, lng, category) {
    const { Place, SearchNearbyRankPreference } = await google.maps.importLibrary("places");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    const location = new google.maps.LatLng(lat, lng);

    const categoryType = this.getCategoryType(category);
    console.log(`Searching category: ${categoryType}`);

    const request = {
      fields: ["displayName", "location", "businessStatus", "id"], // ✅ FIXED: no "placeId"
      locationRestriction: {
        center: location,
        radius: 3000, // 3km
      },
      includedPrimaryTypes: [categoryType],
      maxResultCount: 10,
      rankPreference: SearchNearbyRankPreference.POPULARITY,
      language: "en",
      region: "jp",
    };

    const { places } = await Place.searchNearby(request);

    if (places.length) {
      console.log(`Found ${places.length} places for ${categoryType}`);

      const { LatLngBounds } = await google.maps.importLibrary("core");
      const bounds = new LatLngBounds();

      // 🚀 Use for...of loop for async-safe calls
      for (const place of places) {
        const pos = place.location.toJSON();

        // Add marker
        const markerView = new AdvancedMarkerElement({
          map: this.map,
          position: pos,
          title: place.displayName,
        });

        this.markers.push(markerView);
        bounds.extend(pos);

        // 🚀 Fetch detailed info (reviews)
        const service = new google.maps.places.PlacesService(this.map);

        service.getDetails({
          placeId: place.id,
          fields: ["reviews", "rating", "user_ratings_total"]
        }, (details, status) => {
          if (status === google.maps.places.PlacesServiceStatus.OK) {
            const firstReview = details.reviews?.[0]?.text || "No reviews available";

            // 🚀 Build card style + reviews
            const ratingColor = details.rating >= 4.5 ? "#28a745" :
                    details.rating >= 3.0 ? "#fd7e14" : "#dc3545";

              const cardHtml = `
                <div class="d-flex justify-content-center">
                  <div class="card mb-2" style="cursor: pointer; max-width: 300px;" onclick="
                      const map = window.googleMapsStimulusMapInstance;
                      map.setCenter({ lat: ${pos.lat}, lng: ${pos.lng} });
                      map.setZoom(16);
                    ">
                    <div class="card-body shadow-sm d-flex justify-content-between">
                      <div class="">
                        <h5 class="card-title">${place.displayName}</h5>
                        <span class="badge bg-primary mb-2">${category}</span>
                        <p class="card-text">Business status: ${place.businessStatus || "Unknown"}</p>
                        <p class="card-text" style="color: ${ratingColor}; font-weight: bold;">
                          Rating: ${details.rating || "N/A"} (${details.user_ratings_total || 0} reviews)
                        </p>
                      </div>
                      <div class="">
                        <a target="_blank" href="https://maps.google.com/maps/dir/?api=1&destination=${pos.lat},${pos.lng}" tabindex="0">
                          <i class="fa-solid fa-location-dot fa-2xl"></i>
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
              `;

            this.markTarget.insertAdjacentHTML("beforeend", cardHtml);
          } else {
            console.warn(`Could not fetch details for ${place.displayName}: ${status}`);
          }
        }); // end getDetails
      } // end for...of

      this.map.fitBounds(bounds);

    } else {
      console.log(`No results found for category: ${category}`);
    }
  }

  clearMarkers() {
    console.log("Clearing markers...");
    this.markers.forEach(marker => {
      marker.map = null; // Remove marker from map
    });
    this.markers = [];
  }

  getCategoryType(category) {
    switch (category) {
      case "Vet":
        return "veterinary_care";
      case "Petshop":
        return "pet_store";
      default:
        return "pet_store"; // Fallback
    }
  }
}
