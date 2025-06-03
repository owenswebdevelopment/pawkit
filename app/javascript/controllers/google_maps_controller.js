import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchButton", "mark"]

  connect() {
    // Initialize map centered at Meguro by default
    this.map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 35.633998, lng: 139.715653 }, // Meguro
      zoom: 13,
      mapId: "YOUR_MAP_ID" // Optional
    });

    window.googleMapsStimulusMapInstance = this.map; // For click-to-center

    this.markers = []; // Track markers

    // Delegate click for Save buttons
    this.markTarget.addEventListener("click", (event) => {
      if (event.target.closest(".save-location-btn")) {
        this.saveLocation(event);
      }
    });
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

      // Clear old cards
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
      fields: ["displayName", "location", "businessStatus", "id"],
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

        // Fetch detailed info (with address, phone)
        const service = new google.maps.places.PlacesService(this.map);

        service.getDetails({
          placeId: place.id,
          fields: [
            "reviews",
            "rating",
            "user_ratings_total",
            "formatted_address",
            "formatted_phone_number"
          ]
        }, (details, status) => {
          if (status === google.maps.places.PlacesServiceStatus.OK) {
            const placeData = {
              place_id: place.id,
              name: place.displayName,
              latitude: pos.lat,
              longitude: pos.lng,
              business_status: place.businessStatus,
              rating: details.rating || null,
              user_ratings_total: details.user_ratings_total || 0,
              first_review: details.reviews?.[0]?.text || null,
              category: category, // Use selected category
              address: details.formatted_address || "Unknown address",
              phone: details.formatted_phone_number || "Unknown"
              // email: you can add if you want — not returned by Google
            };

            const ratingColor = details.rating >= 4.5 ? "#28a745" :
                                details.rating >= 3.0 ? "#fd7e14" : "#dc3545";

            const cardHtml = `
              <div class="d-flex justify-content-center">
                <div class="card mb-2" style="cursor: pointer; width: 400px;">
                  <div class="card-body shadow-sm d-flex justify-content-between">
                    <div>
                      <h5 class="card-title">${place.displayName}</h5>
                      <span class="badge bg-primary mb-2">${category}</span>
                      <p class="card-text">Business status: ${place.businessStatus || "Unknown"}</p>
                      <p class="card-text" style="color: ${ratingColor}; font-weight: bold;">
                        Rating: ${details.rating || "N/A"} (${details.user_ratings_total || 0} reviews)
                      </p>
                      <p class="card-text">Address: ${details.formatted_address || "Unknown"}</p>
                      <p class="card-text">Phone: ${details.formatted_phone_number || "Unknown"}</p>
                      <button class="btn btn-outline-primary save-location-btn mt-2"
                        data-place='${encodeURIComponent(JSON.stringify(placeData))}'>
                          Save Location
                      </button>

                    </div>
                    <div>
                      <a target="_blank" href="https://maps.google.com/maps/dir/?api=1&destination=${pos.lat},${pos.lng}">
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
        });
      }

      this.map.fitBounds(bounds);

    } else {
      console.log(`No results found for category: ${category}`);
    }
  }

  saveLocation(event) {
    const button = event.target.closest(".save-location-btn");
    const encodedPlace = button.getAttribute("data-place");
    const placeData = JSON.parse(decodeURIComponent(encodedPlace));

    console.log("Saving place:", placeData);

    fetch("/locations", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ location: placeData })
    })
    .then(response => {
      if (response.ok) {
        console.log("Place saved successfully!");
        button.classList.remove("btn-outline-primary");
        button.classList.add("btn-success");
        button.innerText = "Saved!";
      } else {
        console.error("Failed to save place.");
      }
    });
  }

  clearMarkers() {
    console.log("Clearing markers...");
    this.markers.forEach(marker => {
      marker.map = null;
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
        return "pet_store";
    }
  }
}
